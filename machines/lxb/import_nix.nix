{ config, pkgs, ... }:
let IPaddressPorts = import ../../modules/IPaddress-ports.nix;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/i18n.nix
    ../../modules/binaryCaches.nix
    ../../modules/systemPackages.nix
    # ../../modules/enable_flake.nix
    ../../modules/network.nix
    ../../modules/nix-build.nix
    ../../modules/service/jupyter
    # ../../modules/service/nginx
    # ../../modules/service/mysql
    ../../modules/service/airflow
    # ../../modules/service/github-runner
    # ../../modules/service/monitoring/grafana.nix
    # ../../modules/service/monitoring/prometheus.nix
    # ../../modules/service/monitoring/loki
    # ../../modules/service/monitoring/promtail
    # ../../modules/service/jsy-archiver
    # ../../modules/service/redis
    ../../users/lxb.nix
  ];
  # serviceContainers.warehouser = {
  #   mainUser = "liuxiaobo";
  #   mysqlServerId = 4;
  #   mysqlMasterHost = IPaddressPorts.bishop;
  #   mysqlMasterPort = IPaddressPorts.mysqlTcpPort;
  # };
  services.airflow = { enable = false; };

  services.wind-importer = {
    enable = false;
    startOnBoot = true;
    user = "lxb";
    dependency =
      [ "network.target" "redis.service" "clickhouse-server.service" ];
    webServerPort = 15040;
    redis = {
      host = "localhost";
      port = 6379;
      pubStreamsRedisNum = 1;
    };
    clickhouse = {
      host = "localhost";
      port = 9005;
    };
  };
}
