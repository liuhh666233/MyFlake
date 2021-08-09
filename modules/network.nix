{ config, pkgs, ... }:

{
        networking.useDHCP = false;
        networking.hostName = "lxb";
        networking.interfaces.enp0s.useDHCP = true;
        networking.interfaces.wlp165s0.useDHCP = true;

        nixpkgs.config.allowUnfree = true;

        services.openssh.enable = true;
        networking.firewall.enable = false;

}
