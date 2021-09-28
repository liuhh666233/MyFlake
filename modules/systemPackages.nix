{ config, pkgs, lib, ... }: {
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
    borgbackup

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
    nixfmt
    sqlitebrowser
    cloud-init
    win-virtio
    nixopsUnstable
    # nixops

    # VPN
    v2ray
    qv2ray
    clash

    # Python
    python3
    (python38.withPackages (ps:
      with ps; [
        jupyter
        jupyter_core
        notebook
        ipython
        ipykernel
        pandas
        numpy
        systemd
        click
        jinja2
        clickhouse-driver
        flask
        autopep8
        pip
        pyyaml
        boto
        boto3
        pytz
        websockets
      ]))
    # GO
    go

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
    gnome.gnome-backgrounds
    gnome.gnome-weather
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor
    gnomeExtensions.unlock-dialog-background
    gnomeExtensions.sound-output-device-chooser

  ];
}
