# MyFlake

lxb / lhh 在各台机器上的 home-manager 配置，以及几个项目模板。

## 机器

| 配置名 | 机器 | 系统 |
|---|---|---|
| `lxb@athena` | athena | NixOS 24.11（系统由公司仓库管理） |
| `lxb@kami` | kami | NixOS 24.11（系统由公司仓库管理） |
| `lhh@lhh-macos` | lhh-mac | macOS + nix-darwin |

HM 用自己的 nixpkgs（26.05），与宿主系统的版本无关。

## 使用

```bash
nh home switch            # 按「用户@主机名」自动选配置，构建后显示包的版本差异
home-manager switch --flake .   # 不用 nh 时的等价写法
nix flake update          # 升级全部输入
```

新机器第一次切换（还没有 nh 和 home-manager 命令时）：

```bash
nix run home-manager/release-26.05 -- switch --flake . -b hm-bak
```

`-b hm-bak` 把已存在的同名文件改名为 `*.hm-bak` 备份，不加的话遇到已有文件会中止。
用 `nix profile install` 装过、和 HM 重复的包要先 `nix profile remove`，否则激活失败。

## 目录

```
home/
  default.nix     公共入口
  packages.nix    包清单（Linux / macOS 分开列）
  shell.nix       fish、fzf、direnv、PATH
  git.nix         git、gh
  hosts/<主机>.nix  只属于某台机器的设置
templates/        nix flake init -t .#<模板名>
homelab/          homelab 首页面板与群晖上的 docker-compose，不属于 Nix 配置
```

加包改 `home/packages.nix`；只在一台机器上要的东西写进 `home/hosts/<主机>.nix`。

## oh-my-fish 主题

```bash
omf-install
omf install lambda && omf theme lambda
```
