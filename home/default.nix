{ config, pkgs, ... }:

{
  imports = [ ./packages.nix ./shell.nix ./git.nix ];

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    homeFlake = "${config.home.homeDirectory}/github/MyFlake";
  };

  # 只在 Linux 开：lhh-mac 连不上 GitHub Releases，预建索引下载不下来，构建会一直卡住。
  programs.nix-index.enable = pkgs.stdenv.isLinux;
  programs.nix-index-database.comma.enable = pkgs.stdenv.isLinux;
}
