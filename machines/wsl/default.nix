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

  # wonder.productionAirflow = {
  #   enable = false;
  #   warehousePath = "/var/lib/wonder/warehouse";
  #   redis = {
  #     host = baseParams.hosts.localhost;
  #     port = baseParams.ports.redisTcpPort;
  #     datasourcerRedisNum =
  #       baseParams.redisDatabases.dataSourcerFilePathDatabaseNum;
  #     pubStreamsRedisNum =
  #       baseParams.redisDatabases.dataPipelinePubsubDatabaseNum;
  #   };
  #   clickhouse = {
  #     host = baseParams.hosts.thor;
  #     port = baseParams.ports.warehouserClickhouseTcpPort;
  #   };
  # };

  services.printing.enable = lib.mkForce false;

  services.avahi.enable = lib.mkForce false;

  services.blueman.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  system.stateVersion = "22.05";
  # Update nix config
  nix = {
    gc.automatic = lib.mkForce false;
    autoOptimiseStore = false;
  };

}
