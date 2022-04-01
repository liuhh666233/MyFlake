{ config, pkgs, ... }:

{
  networking.useDHCP = false;

  networking.hostName = "lxb";
  # head -c 8 /etc/machine-id
  networking.hostId = "8d885cfc";

  services.openssh.enable = true;

  networking.firewall.enable = false;

  networking.networkmanager.enable = true;
}
