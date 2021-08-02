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
      tig
      tmux
      starship
      fish
      z-lua
      bat
      tree
      ncdu
      ripgrep
      synergy
      remmina


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
      mailspring

    # VPN
      v2ray
      qv2ray

    # Python
      python3
      (python38.withPackages(ps: with ps; [ jupyter jupyter_core notebook ipython ipykernel pandas numpy systemd click jinja2 clickhouse-driver flask autopep8 pip]))

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
      gnome.gnome-remote-desktop
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.system-monitor
      gnome.gnome-weather
      gnomeExtensions.sound-output-device-chooser
      
  ];
}
