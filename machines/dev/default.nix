{ config, pkgs, ... }:
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/service/jupyter
  ];

  # Bootloader.

  boot.loader.systemd-boot.enable = false;   
  
  boot.loader.grub.enable = true;

  boot.loader.grub.device = "/dev/sdc";

  boot.loader.grub.useOSProber = true;

  vital.mainUser = "lhh";

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

  # Enable automatic login for the user.
  services.getty.autologinUser = "lhh";

  services.openssh.enable = true;

  networking.hostName = "dev"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  virtualisation.docker.enable = true;

  nix = {
    # Automatically optimize storage spaces /nix/store
    autoOptimiseStore = false;

    # Automatic garbage collection
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 120d";
    };
  };

  system.stateVersion = "22.05";

}
