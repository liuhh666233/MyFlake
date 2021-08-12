{ config, pkgs, ... }: {
  config = {
    services.nginx.enable = true;
    services.nginx.virtualHosts."myhost.org" = {
      addSSL = true;
      enableACME = true;
      root = "/var/lib/wonder/warehouse/report";
    };
    systemd.services.nginx.serviceConfig.ReadWritePaths =
      [ "/var/spool/nginx/logs/" ];

  };
}
