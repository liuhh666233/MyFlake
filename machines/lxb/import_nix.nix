{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/i18n.nix
    ../../modules/binaryCaches.nix
    ../../modules/systemPackages.nix
    ../../modules/enable_flake.nix
    ../../modules/network.nix
    ../../modules/borg.nix
    ../../users/lxb.nix
    ../../users/liuxb.nix
  ];

  services.borgbackup = {
    minbarPath = "/var/lib/wonder/warehouse/archive/minbar/2016/01";

    minbarRepo =
      "ssh://lxb@ec2-52-83-150-210.cn-northwest-1.compute.amazonaws.com.cn/home/lxb/backup/minbar";

  };
}
