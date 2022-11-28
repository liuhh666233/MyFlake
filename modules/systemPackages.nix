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
    ripgrep
    nodejs

    # Work
    git
    gftp
    git-lfs
    clickhouse-cli
    graphviz
    nixfmt
    nixopsUnstable
    gnupg1
    redis
    morph
    streamlit
    nixops_unstable
    # colmena
    duckdb

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
        openpyxl
        xlrd
        requests
      ]))
    # GO
    go
    gophernotes
    gopls

    # C++
    gcc
    gdb
    clang_11
    lua
    cmake
    doxygen
    cling

    # C++
    gcc
    gdb
    clang_11
    lua
    cmake
    doxygen
  ];

}
