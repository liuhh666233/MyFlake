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
    ../../users/lxb.nix
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

  services.printing.enable = lib.mkForce false;

  services.avahi.enable = lib.mkForce false;

  services.blueman.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;

}
