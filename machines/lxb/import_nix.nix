{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/i18n.nix
    ../../modules/binaryCaches.nix
    ../../modules/systemPackages.nix
    ../../modules/enable_flake.nix
    ../../modules/network.nix
    ../../modules/service/jupyter
    ../../modules/service/nginx
    ../../modules/github-runner
    ../../users/lxb.nix
    ../../users/liuxb.nix
  ];

}
