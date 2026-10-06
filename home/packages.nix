{ lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs;
    [
      # 命令行
      bat
      bottom
      btop
      fd
      gettext
      htop
      jq
      nixfmt
      oh-my-fish
      p7zip
      ripgrep
      rsync
      silver-searcher
      sqlite
      tmux
      translate-shell
      tree
      xh

      # 开发
      black
      nodejs
      pnpm
      pre-commit
      python3
      rustup
      uv

      pkgs-unstable.rtk
    ] ++ lib.optionals stdenv.isLinux [ lsof nvitop sshfs ]
    ++ lib.optionals stdenv.isDarwin [
      bc
      dnsutils
      glances
      inetutils
      netcat
      nmap
    ];
}
