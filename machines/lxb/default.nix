{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./import_nix.nix
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
  system.stateVersion = "21.05";

  vital.jupyter-notebook = { enable = true; };

  virtualisation.docker.enable = true;

}

