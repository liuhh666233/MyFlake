{ lib, ... }:

{
  programs.git.settings.user.name = "liuxb";

  # macOS 上 fish 不会自己加 nix 的路径，这几项原先靠手设的通用变量 fish_user_paths 提供。
  # 必须排在 shell.nix 的 fish_add_path 之前执行，那边要把 ~/.nix-profile/bin 等挪到最前面。
  programs.fish.shellInit = lib.mkBefore ''
    fish_add_path --path --move --prepend /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
    fish_add_path --path --append /opt/homebrew/bin
  '';
}
