{ config, pkgs, lib, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System
    wget
    ibus
    docker
    inetutils
    dpkg
    silver-searcher
    tig
    tmux
    starship
    fish
    borgbackup
    jq
    black

    # Work
    git
    awscli2
    gftp
    dbeaver
    clickhouse-cli
    graphviz
    nixfmt
    sqlitebrowser
    nixopsUnstable
    gnupg1
    redis
    morph
    streamlit
    nixops_unstable

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
        lark
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
    cling

  ];
  nixpkgs.config.permittedInsecurePackages = [ "electron-9.4.4" ];
}
