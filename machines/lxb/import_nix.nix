{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/i18n.nix
    ../../modules/binaryCaches.nix
    ../../modules/systemPackages.nix
    # ../../modules/enable_flake.nix
    ../../modules/network.nix
    ../../modules/nix-build.nix
    ../../modules/service/jupyter
    ../../modules/service/nginx
    ../../modules/service/mysql
    # ../../modules/service/github-runner
    ../../modules/service/monitoring/grafana.nix
    ../../modules/service/monitoring/prometheus.nix
    # ../../modules/service/monitoring/loki
    # ../../modules/service/monitoring/promtail
    # ../../modules/service/jsy-archiver
    # ../../modules/service/redis
    ../../users/lxb.nix
    ../../users/liuxb.nix
  ];

}
