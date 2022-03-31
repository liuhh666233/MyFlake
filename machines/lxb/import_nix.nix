{ config, pkgs, lib, ... }:
with lib;
let
  baseParams = config.wonder.baseParams;
  vitalParams = config.wonder.vitalParams;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/i18n.nix
    ../../modules/binaryCaches.nix
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    ../../modules/nix-build.nix
    ../../modules/service/jupyter
    ../../modules/service/mysql
    # ../../modules/service/airflow
    ../../modules/service/redis
    ../../users/lxb.nix
  ];
  services.airflow = { enable = false; };

  serviceContainers.warehouser = {
    enable = false;
    user = "liuxiaobo";
    loki = {
      host = "lxb";
      port = 3100;
    };
  };
  services.base-exporters.enable = false;
  services.redis-exporter.enable = false;
}
