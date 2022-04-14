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
    flameshot
    black

    # Work
    vscode
    google-chrome
    git
    freeoffice
    awscli2
    gftp
    dbeaver
    clickhouse-cli
    graphviz
    nixfmt
    sqlitebrowser
    nixopsUnstable
    airflow-python
    gnupg1
    redis
    # Personal
    beancount
    fava

    # VPN
    # v2ray
    # qv2ray
    # openvpn

    # Python
    python3
    (python3.withPackages (ps:
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
        pytz
        websockets
        black
        beancount
        PyGithub
        paramiko
        xmltodict
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
