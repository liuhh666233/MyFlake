{config, pkgs, ...}:
{ 
 # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   # Dedit
      vim
      neovim
      typora
      emacs
      zeal

   # System
      wget
      spotify
      ibus
      fcitx
      docker
      lsd
      glances
      duf
      p7zip
      unrar
      inetutils
      dpkg
      ag

   # Work
      vscode
      google-chrome
      git
      freeoffice
      goffice
      awscli2
      gftp
      zoom-us
      dbeaver
      clickhouse-cli
      graphviz

   # VPN
      v2ray
      qv2ray

   # Python
      python3
      (python38.withPackages(ps: with ps; [ jupyter jupyter_core notebook ipython ipykernel pandas numpy systemd click jinja2]))

   # C++
      gcc
      gdb
      clang
      nodejs
      lua
      cmake
      doxygen
      doxygen_gui
     
   # Gnome extension
      chrome-gnome-shell
      gnome.gnome-tweak-tool
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.system-monitor
      gnome.gnome-weather
      gnomeExtensions.sound-output-device-chooser

   # wine
      wineWowPackages.stable
      wine
      (wine.override { wineBuild = "wine64"; })
      wineWowPackages.staging
      (winetricks.override { wine = wineWowPackages.staging; })
     
  ];

  environment.interactiveShellInit = ''
        alias gs='git status'
        alias ga='git add'
        alias gc='git commit -m'
        alias nu='nix flake lock --update-input '
        alias nw='sudo nixos-rebuild switch --flake .#'
        alias nm='nixos-rebuild build-vm --flake .#'
    '';
}
