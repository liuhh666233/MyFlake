{ config, pkgs, ... }:
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    ../../modules/service/jupyter
    ../../users/lxb.nix
  ];

  vital.mainUser = "liuxiaobo";

  vital.graphical.enable = true;

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

  vital.services.filerun = {
    enable = true;
    port = baseParams.ports.fileRunWebPort;
  };

  wonder.binaryCaches = {
    enable = true;
    nixServe.host = baseParams.hosts.sisyphus;
    nixServe.port = baseParams.ports.nixServerPort;
  };

  wonder.remoteNixBuild = {
    enable = true;
    user = "lxb";
    host = "sisyphus";
  };

  wonder.home-manager = {
    enable = true;
    user = "lxb";
    extraImports = [ ../../home/by-user/nix-dev.nix ];
    vscodeServer.enable = false;
    archer = {
      enable = true;
      remote_host = baseParams.hosts.bishop;
      remote_port = 22;
      remote_user = "lxb";
      ssh_key = "/home/lxb/.ssh/id_rsa";
      remote_warehouse_root = "/var/lib/wonder/warehouse";
      local_warehouse_root = "/var/lib/wonder/warehouse";
      ssh_proxy = "";
    };
    sshConfig = {
      enable = true;
      ssh_key = "/home/lxb/.ssh/id_rsa";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    port = 5432;
    dataDir = "/var/lib/postgresql/11";
    checkConfig = true;
  };

  services.airflow = {
    enable = false;
    startOnBoot = false;
    dependency = [ "network.target" ];
    user = "root";
    airflowHome = "/var/lib/wonder/warehouse/airflow";
    airflowDags = pkgs.airflow-production-dags;
    webServerPort = baseParams.ports.airFlowWebPort;
  };

  nixpkgs.config.allowUnfree = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab # disk usage analyzer
    cheese # photo booth
    eog # image viewer
    epiphany # web browser
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
    file-roller # archive manager
    seahorse # password manager

    # these should be self explanatory
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-weather
    gnome-disk-utility
    pkgs.gnome-connections
  ];

}
