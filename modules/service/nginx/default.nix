{ config, pkgs, ... }:
let
  proxyConfig = { listenPort, proxyUrl, extraLocations ? { }, }: {
    forceSSL = false;
    enableACME = false;

    # basicAuthFile = ./admin;

    listen = [{
      addr = "0.0.0.0";
      port = listenPort;
    }];
    locations = { "/" = { proxyPass = proxyUrl; }; } // extraLocations;
  };
in {
  config = {

    services.nginx = {
      enable = true;
      # Enable recommended proxy settings.
      recommendedProxySettings = true;
      # Enable recommended TLS settings.
      recommendedTlsSettings = true;
      # Enable recommended optimisation settings.
      recommendedOptimisation = true;
      virtualHosts."127.0.0.1" = {
        forceSSL = false;
        enableACME = false;
        # listen = [{
        #   addr = "0.0.0.0";
        #   port = 10000;
        # }];

        locations = {
          "/" = {
            proxyPass = "http://192.168.110.15";
            extraConfig = ''
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };
        };
      };

    };

    networking.firewall.allowedTCPPorts = [ 10000 ];
  };
}
