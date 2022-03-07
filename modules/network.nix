{ config, pkgs, ... }:

{
  networking.useDHCP = false;

  networking.hostName = "lxb";
  # head -c 8 /etc/machine-id
  networking.hostId = "8d885cfc";

  networking.interfaces.wlp165s0.useDHCP = true;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  services.openssh.extraConfig = ''
    ClientAliveInterval 3
    ClientAliveCountMax 10
  '';

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;

  services.strongswan = {
    enable = false;
    secrets = [ "ipsec.d/ipsec.nm-l2tp.secrets" ];
  };

}
