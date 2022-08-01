{ config, pkgs, ... }:
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    # ../../modules/service/jupyter
  ];

  boot.loader.systemd-boot.enable = false;

  vital.mainUser = "lhh";

  vital.graphical.enable = true;

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.defaultGateway = "192.168.31.88";

  networking.nameservers = [ "192.168.31.88" ];

  wonder.home-manager = {
    enable = true;
    user = "lhh";
    extraImports = [ ../../home/by-user/nix-dev.nix ];
    vscodeServer.enable = false;
    archer = {
      enable = false;
      remote_host = baseParams.hosts.bishop;
      remote_port = 22;
      remote_user = "lxb";
      ssh_key = "/home/lhh/.ssh/id_rsa";
      remote_warehouse_root = "/var/lib/wonder/warehouse";
      local_warehouse_root = "/var/lib/wonder/warehouse";
      ssh_proxy = "";
    };
    sshConfig = {
      enable = true;
      ssh_key = "/home/lhh/.ssh/id_rsa";
    };
  };

  system.stateVersion = "22.05";
}
