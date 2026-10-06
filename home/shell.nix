{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      "gs" = "git status";
      "ga" = "git add";
      "gl" = "git log";
      "gp" = "git push";
      "gc" = "git commit -m";
      "gb" = "git branch";
      "gd" = "git diff";
      "te" = "trans -s en -t zh";
      "tz" = "trans -s zh -t en";
    };
    # PATH 顺序排错的后果是旧版本盖住新版本，且不报错：~/.local/bin（claude 包装脚本）
    # > ~/.nix-profile/bin（要盖过系统和 fish_user_paths 带进来的旧版、`pnpm self-update` 留下的旧 pnpm）
    # > $PNPM_HOME/bin（pnpm 11 的全局命令）> $PNPM_HOME（pnpm 9/10 留下的旧全局命令）。
    shellInit = ''
      set -gx PNPM_HOME $HOME/.local/share/pnpm
      fish_add_path --path --move --prepend $HOME/.local/bin $HOME/.cargo/bin $HOME/.nix-profile/bin $PNPM_HOME/bin $PNPM_HOME

      source (${pkgs.z-lua}/bin/z --init fish | psub)

      # 禁用 fish 的目录补全
      set -g fish_complete_dirs 0

      set fzf_fd_opts --hidden --exclude=.git
      fzf_configure_bindings --git_status --history=\ch --processes=\co --variables --directory --git_log
    '';
    plugins = [{
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }];
  };

  # 关掉 fzf 自带的 fish 集成：它的 Ctrl-R/Ctrl-T/Alt-C 会覆盖 fzf-fish 插件的绑定，且不报错。
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
