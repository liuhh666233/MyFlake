{ config, pkgs, ... }: {
  config = {

    services.nginx = {
      enable = true;
      # Enable recommended proxy settings.
      recommendedProxySettings = true;
      # Enable recommended TLS settings.
      recommendedTlsSettings = true;
      virtualHosts."localhost" = {
        listen = [{
          addr = "0.0.0.0";
          port = 10000;
        }];
        locations = {
          "/" = { proxyPass = "http://localhost:5000"; };
          "~ \"/monitor/(.*)\"" = { proxyPass = "http://localhost:5000/$1"; };
          "~ \"/monitor2/(.*)\"" = { proxyPass = "http://localhost:5001/$1"; };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 10000 ];
  };
}
