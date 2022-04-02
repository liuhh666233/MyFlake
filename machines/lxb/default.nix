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

  wonder.binaryCaches = {
    enable = true;
    nixServe.host = baseParams.hosts.sisyphus;
    nixServe.port = baseParams.ports.nixServerPort;
  };

  wonder.remoteNixBuild = {
    enable = true;
    user = "root";
    host = "sisyphus";
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
