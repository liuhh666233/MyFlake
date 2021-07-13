{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/i18n.nix
      ../../modules/binaryCaches.nix
      ../../modules/systemPackages.nix
      ../../modules/enable_flake.nix
      ../../modules/network.nix
      ../../modules/service/clickhouse
      ../../users/lxb.nix
      ../../users/liuxb.nix
    ];
}
