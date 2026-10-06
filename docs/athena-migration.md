# athena 迁移到新的 home-manager 配置

状态：**未迁移**。kami、lhh-mac 已于 2026-10-06 迁移（见文末「已完成」）。

## 现状

- athena 上的 HM 实际已经失效：`home-manager-path` 不在 nix profile 里，
  `~/.config/fish/config.fish` 是手改过的普通文件（`umask 002`、`~/.local/bin`、pnpm 的 PATH）。
  这些设置已经写进 `home/hosts/athena.nix` 和 `home/shell.nix`。
- nix profile 里有 17 个手装包与 HM 重复。激活前必须先删掉，否则 `nix profile` 报文件冲突，激活失败。
- 2026-10-06 时 profile 是第 28 代。以执行时为准，下面的脚本会自己读取。

## 第一步：切换

在 athena 上用 bash 执行。执行期间 rtk、gh、node 会有几十秒不在 PATH 里，在普通终端里跑，不要在 Claude Code 会话里跑。

```bash
#!/usr/bin/env bash
# 删掉与 HM 重复的手装包，再激活 lxb@athena；任何一步失败都把 profile 回滚到执行前。
set -uo pipefail
cd ~/github/MyFlake && git pull --ff-only
A=$(nix build -o /tmp/hm-athena --print-out-paths '.#homeConfigurations."lxb@athena".activationPackage' 2>&1 | tail -1)
[[ "$A" == /nix/store/*-home-manager-generation ]] || { echo "build failed: $A"; exit 1; }
G0=$(readlink "$(readlink ~/.nix-profile)" | sed -E 's/profile-([0-9]+)-link/\1/')
[[ "$G0" =~ ^[0-9]+$ ]] || { echo "cannot determine profile generation: '$G0'"; exit 1; }
echo "generation: $A"; echo "profile before: $G0"

nix profile remove black direnv gettext gh htop jq lsof nodejs_23 nvitop oh-my-fish pnpm python3 rtk rustup sqlite sshfs uv || {
  echo "nix profile remove failed; rolling back to $G0"; nix profile rollback --to "$G0"; exit 1; }

if ! HOME_MANAGER_BACKUP_EXT=hm-bak "$A/activate"; then
  echo "activation failed; rolling back profile to $G0"
  nix profile rollback --to "$G0"
  exit 1
fi
echo "OK. backups:"; find ~/.config -name '*.hm-bak'
```

预期备份成 `*.hm-bak` 的文件：`~/.config/fish/config.fish`、`~/.config/git/ignore`、`~/.config/gh/config.yml`。

## 第二步：验证

开一个新终端：

```fish
for b in git gh node pnpm rtk fzf nh home-manager; echo $b (command -s $b); end   # 都应在 ~/.nix-profile/bin
umask                                   # 0002
string join \n $PATH[1..5]              # ~/.local/bin、~/.cargo/bin、~/.nix-profile/bin 在最前
git config user.email; gh auth status
~/.local/share/pnpm/claude --version    # 直接调 pnpm 装的 claude；~/.local/bin/claude 包装脚本会停下来等回车
nh home switch --dry                    # 应选中 lxb@athena，且无差异
```

## 第三步：用 pnpm 11 重装全局包（可推迟到第一次升级前）

**为什么要做：** pnpm 11 的全局包放在 `global/v11`，全局命令放在 `$PNPM_HOME/bin`；它看不到 pnpm 9 装在
`global/5` 里的包。旧命令在 node 24 下都能用：6 个 CLI 的 `--version` 正常，node-pty、bcrypt 能加载。
但用 pnpm 11 执行 `pnpm add -g` 或 `pnpm update -g` 时，新版本会装到 `$PNPM_HOME/bin`。

**为什么要加 `--allow-build`：** pnpm 11 默认不执行依赖的安装脚本。claude-code、opencode-ai、happy、ccs
四个包本身，以及 node-pty、bcrypt、esbuild、msgpackr-extract 四个依赖都有安装脚本，不放行就装不全。
kami 上 claude 报过「native binary not installed」，原因就是这个。

2026-10-06 时 athena 的全局包与版本：

```fish
pnpm add -g @anthropic-ai/claude-code@2.1.280 @getpaseo/cli@0.10.3 @kaitranntt/ccs@7.41.0 \
  @openai/codex@0.145.0 happy@1.2.5 opencode-ai@1.18.25 \
  --allow-build=@anthropic-ai/claude-code --allow-build=opencode-ai --allow-build=happy \
  --allow-build=@kaitranntt/ccs --allow-build=node-pty --allow-build=bcrypt \
  --allow-build=esbuild --allow-build=msgpackr-extract

for c in claude codex opencode happy paseo ccs
  echo $c (command -s $c) ($PNPM_HOME/bin/$c --version 2>&1 | head -1)
end
```

逐个看结果：
- 报 postinstall 没执行：用 `pnpm add -g <包>@<版本> --allow-build=<包>` 单独重装。
- 报缺依赖：kami 上的 gemini 就是这样，报 `ERR_MODULE_NOT_FOUND`，原因是 pnpm 11 的隔离布局。
  执行 `pnpm remove -g <包>`，退回旧命令。

**同一步里必须改 `~/.local/bin/claude`：** 把 `REAL_CLAUDE="$HOME/.local/share/pnpm/claude"` 改成
`REAL_CLAUDE="$HOME/.local/share/pnpm/bin/claude"`。不改的话，包装脚本会继续启动旧版本，并且不报错。

## 第四步：收尾（可选）

- **删掉 `~/.gitconfig`：** 它的内容 HM 都已经提供了；`safe.directory` 改成了通配 `/var/work_space_lyc/*`。
  git 先读 `~/.config/git/config`，再读 `~/.gitconfig`，后者留着会覆盖以后对 HM git 配置的修改，并且不报错。
  `~/.gitconfig-lyc` 保留，`home/hosts/athena.nix` 引用了它。
- **删掉备份和旧包：** 确认没问题后删掉 `*.hm-bak`。第三步做完以后，再删掉 `$PNPM_HOME` 下的旧命令和 `global/5`。

## 回滚

```bash
nix profile rollback --to <第一步打印的 profile before>
rm ~/.config/fish/config.fish && mv ~/.config/fish/config.fish.hm-bak ~/.config/fish/config.fish
```

`git/ignore`、`gh/config.yml` 按同样的方式从 `.hm-bak` 恢复。

---

## 已完成（2026-10-06）

| 机器 | HM 代数 | 迁移前的 profile 代数（回滚用） | 备注 |
|---|---|---|---|
| kami | 19 → 20 | 112 | pnpm 全局包已用 pnpm 11 重装，gemini 除外 |
| lhh-mac | 2 → 3 | 25 | 登录 shell 升级到 fish 4.7，之前打开的终端要重开 |

## 同一批次留下的其他事项

1. **私密内容入库：** 仓库改成私有以后，纳入以下内容。
   - ssh 主机表：三台机器各有一份，内容不同，要先合并成公共部分加每台机器各自的部分；
   - `~/.claude/*.md`；
   - lyc 的 git 身份；
   - athena 的 `gh.fish` 和 `~/.local/bin/claude` 包装脚本。
2. **kami 的 gemini：** 仍是 pnpm 10 装的旧命令，依赖 `global/5`。在它迁走之前不要删 `global/5`。
   用 pnpm 11 重装会缺 `@opentelemetry/semantic-conventions`。可以试 `--config.node-linker=hoisted`，或者改用 npm 安装；这两种都还没验证。
3. **`fish_user_paths`（kami、lhh-mac）：** 里面混着别的机器的路径。新配置已经显式排好 PATH，这个变量留着只多出几条无效路径。
   要清的话执行 `set -e -U fish_user_paths`。执行后所有正在运行的 fish 会话会立即重算 PATH，挑没有重要会话的时候做。
4. **lhh-mac 上重复的 brew 包：** jq、curl、netcat、bind、bc 现在由 nix 提供，可以 `brew uninstall`。
5. **远端旧分支：** `master` 停在 2022-09-30，它的提交都已包含在 main 里，可以删除。
6. **`~/.claude/rtk-hook.md` 的升级说明已过时：** rtk 改由 HM 从 nixos-unstable 安装。升级方式改为
   `nix flake update nixpkgs-unstable` 后执行 `nh home switch`，不再是 `nix profile upgrade rtk`。
