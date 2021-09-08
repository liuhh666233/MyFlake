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
        listen = [{
          addr = "0.0.0.0";
          port = 10000;
        }];
        locations = {
          "/" = {
            proxyPass = "http://192.168.110.15";
            extraConfig = ''
              ### force timeouts if one of backend is died ##
              proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;

              ### Set headers ####
              proxy_set_header        Accept-Encoding   "";
              proxy_set_header        Host            $host;
              proxy_set_header        X-Real-IP       $remote_addr;
              proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

              ### Most PHP, Python, Rails, Java App can use this header ###
              #proxy_set_header X-Forwarded-Proto https;##
              #This is better##
              proxy_set_header        X-Forwarded-Proto $scheme;
              add_header              Front-End-Https   on;

              ### By default we don't want to redirect it ####
              proxy_redirect     off;
                  '';
          };
        };
      };

    };

    networking.firewall.allowedTCPPorts = [ 10000 ];
  };
}
