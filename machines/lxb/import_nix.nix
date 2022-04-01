{ config, pkgs, ... }:
let

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    ../../modules/service/jupyter
    ../../users/lxb.nix
  ];
}
