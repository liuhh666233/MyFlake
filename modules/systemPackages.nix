{config, pkgs, ...}:
{ 
 # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget
     google-chrome
     vscode 
     python3
     gcc
     clang
     nodejs
     lua
     cmake
     typora
     neovim
     git
     gdb
     docker
     spotify
     ibus
     fcitx
     doxygen
     doxygen_gui
     graphviz
     zeal
     dpkg
     emacs
     lsd
     glances
     duf
     zoom-us
     p7zip
     unrar
     clickhouse-cli
     inetutils
     gftp
     awscli2
     p3x-onenote
     dbeaver
     chrome-gnome-shell
     gnome.gnome-tweak-tool
     gnomeExtensions.appindicator
     gnomeExtensions.dash-to-dock
     gnomeExtensions.system-monitor
     gnome.gnome-weather
     gnomeExtensions.sound-output-device-chooser
     freeoffice
     goffice
     v2ray
     qv2ray
     (python38.withPackages(ps: with ps; [ jupyter jupyter_core notebook ipython ipykernel pandas numpy systemd]))
  ];
}
