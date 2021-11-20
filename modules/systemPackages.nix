{ config, pkgs, lib, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Dedit
    vim
    neovim

    # System
    wget
    ibus
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
    jq

    # Work
    vscode
    google-chrome-latest
    git
    freeoffice
    goffice
    awscli2
    gftp
    zoom-us
    dbeaver
    clickhouse-cli
    graphviz
    nixfmt
    sqlitebrowser
    nixopsUnstable
    nixUnstable
    # nixops

    # Personal
    beancount
    fava

    # VPN
    v2ray
    qv2ray
    openvpn

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
        black
        beancount
      ]))
    # GO
    go
    gophernotes
    gopls

    # C++
    gcc
    gdb
    clang_11
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
    gnome.networkmanager-l2tp
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.system-monitor
    gnomeExtensions.unlock-dialog-background
    gnomeExtensions.sound-output-device-chooser

  ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-9.4.4" ];
}
