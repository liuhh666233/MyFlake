{ config, pkgs, ... }:
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/service/jupyter
    ../../users/lhh.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  vital.mainUser = "lhh";

  vital.graphical.enable = true;

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.defaultGateway = "192.168.31.3";

  networking.nameservers = [ "192.168.31.3" ];

  # Enable automatic login for the user.
  services.getty.autologinUser = "lhh";

  services.openssh.enable = true;

  networking.hostName = "dev"; # Define your hostname.

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
    # https://github.com/vernesong/OpenClash/issues/1960
    # github.com 链接失败, 需要在ssh config中讲ssh.github.com的22端口切换为443端口
    # 部分机场存在此问题.
    sshConfig = {
      enable = false;
      ssh_key = "/home/lhh/.ssh/id_rsa";
    };
  };

  virtualisation.docker.enable = true;

  nix = {
    # Automatically optimize storage spaces /nix/store
    settings = {
      auto-optimise-store = false;
    };

    # Automatic garbage collection
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 120d";
    };
  };

  wonder.binaryCaches = {
    enable = true;
    pubilcKeys = "nas:5DfJlCQhhx/i+mTy8OI6aPZSi1XTuIJYSAPIFmYvYAY=";
    nixServe.host = "192.168.31.126";
    nixServe.port = baseParams.ports.nixServerPort;
  };

  system.stateVersion = "22.05";

}
