{ config, pkgs, ... }: {
  config = {

    services.nginx = {
      enable = true;
      # Enable recommended proxy settings.
      recommendedProxySettings = true;
      # Enable recommended TLS settings.
      recommendedTlsSettings = true;

      config = "
      http {
          server{
              listen 10000;
              location / {
                proxy_pass http://192.168.110.161:10000;
            }
          }
      }
      stream {
            upstream ssh {
                server 192.168.110.161:22;
                }
            server { 
                    listen 10000;
                    server_name 127.0.0.1;
                    proxy_pass ssh;
                    proxy_connect_timeout 1h;
                    proxy_timeout 1h;
                    }
        }
      events {
            worker_connections  1024;
        }
        ";

    };

    networking.firewall.allowedTCPPorts = [ 80 443 10000 ];
  };
}
