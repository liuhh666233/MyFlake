{ lib, pkgs, config, modulesPath, ... }:
with lib;
let
  nixos-wsl = import ./nixos-wsl;
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    ../../modules/service/jupyter
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  vital.mainUser = "nixos";

  users.users.nixos.shell = pkgs.fish;

  vital.graphical.enable = false;

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

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
    user = "nixos";
    extraImports = [ ../../home/by-user/nix-dev.nix ];
    vscodeServer.enable = false;
    archer = {
      enable = true;
      remote_host = baseParams.hosts.bishop;
      remote_port = 22;
      remote_user = "lxb";
      ssh_key = "/home/nixos/.ssh/id_rsa";
      remote_warehouse_root = "/var/lib/wonder/warehouse";
      local_warehouse_root = "/var/lib/wonder/warehouse";
      ssh_proxy = "";
    };
    sshConfig = {
      enable = true;
      ssh_key = "/home/nixos/.ssh/id_rsa";
    };
  };

  services.airflow = {
    enable = true;
    startOnBoot = true;
    enablePostgresqlBackend = true;
    dependency = [ "network.target" ];
    user = config.vital.mainUser;
    webServerPort = baseParams.ports.airFlowWebPort;
    airflowDags = pkgs.airflow-production-dags;
    airflowExecutor = "LocalExecutor";
    postgreSql = {
      host = baseParams.hosts.localhost;
      port = baseParams.ports.postgreSqlTcpPort;
      user = vitalParams.airflow.user;
      password = vitalParams.airflow.password;
      database = vitalParams.airflow.database;
    };
    airflowVariables = {
      AIRFLOW_VAR_WAREHOUSE_PATH = "/var/lib/wonder/warehouse";
      AIRFLOW_VAR_INTRADAY_HOT_ARCHIVE_PATH =
        "/var/lib/wonder/warehouse/hot_data";
      AIRFLOW_VAR_INTRADAY_PIPELINE_DATA_PATH =
        "/var/lib/wonder/warehouse/intradayData";
      AIRFLOW_VAR_MAIL_MIRRORER_RANGE_DAYS = "1";
    };
    airflowConnections = {
      AIRFLOW_CONN_CLICKHOUSE = "http://login:password@localhost:29002/schema";
      AIRFLOW_CONN_BUTLER_REDIS =
        "redis://login:password@localhost:6379/schema?db=6";
    };
  };

  services.printing.enable = lib.mkForce false;

  services.avahi.enable = lib.mkForce false;

  services.blueman.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;

}
