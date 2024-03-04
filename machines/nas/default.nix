{ config, pkgs, ... }:
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/service/tailscale
    # ../../modules/service/samba
    # ../../modules/service/transmission
    # ../../modules/service/aria2
    ../../users/lhh.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  vital.mainUser = "lhh";

  vital.pre-installed.level = 5;

  vital.graphical.enable = false;

  vital.programs.modern-utils.enable = true;

  # Enable automatic login for the user.
  services.getty.autologinUser = "lhh";

  services.openssh.enable = true;

  networking.hostName = "nas"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hostId = "a8e6e22e";

  networking.firewall.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  vital.services.filerun = {
    enable = false;
    workDir = "/var/lib/wonder/nas/filerun";
    port = baseParams.ports.fileRunWebPort;
  };

  services.base-exporters.enable = false;

  virtualisation.docker.enable = true;

  virtualisation.docker.daemon.settings = {
    hosts = [ "tcp://0.0.0.0:2375" "unix:///run/docker.sock" ];
  };

  services.nix-server = {
    enable = false;
    webServerPort = baseParams.ports.nixServerPort;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  wonder.binaryCaches = {
    enable = false;
    nixServe.host = baseParams.hosts.localhost;
    nixServe.port = baseParams.ports.nixServerPort;
  };

  nix = {
    # Automatically optimize storage spaces /nix/store
    settings = {
      trusted-users = [ "lhh" ];
      auto-optimise-store = false;
    };
    # Automatic garbage collection
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 120d";
    };
  };

  # services.cron.systemCronJobs = [ "0 4 * * * root  reboot" ];

  system.stateVersion = "23.11";

}
