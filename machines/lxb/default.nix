{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./import_nix.nix
  ];

  vital.mainUser = "liuxiaobo";

  fonts.fonts = with pkgs; [
    # Add Wenquanyi Microsoft Ya Hei, a nice-looking Chinese font.
    wqy_microhei
    # Fira code is a good font for coding
    fira-code
    fira-code-symbols
    font-awesome-ttf
    inconsolata
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.chrome-gnome-shell.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  # Disable gnome all apps
  # services.gnome.core-utilities.enable = false;

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

  system.stateVersion = "21.05";

  virtualisation.docker.enable = true;

}

