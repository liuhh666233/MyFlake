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

  wonder.binaryCaches = {
    enable = true;
    nixServe.host = baseParams.hosts.sisyphus;
    nixServe.port = baseParams.ports.nixServerPort;
  };

  wonder.remoteNixBuild = {
    enable = true;
    user = "root";
    host = baseParams.hosts.sisyphus;
  };

  nixpkgs.config.allowUnfree = true;

}
