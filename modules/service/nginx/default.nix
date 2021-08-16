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
              server_name monitor.wondercapital.xyz;
              location / {
                proxy_pass http://192.168.110.161:10000;
            }
          }
          server{
              listen 10000;
              server_name clickhouse.wondercapital.xyz;
              location / {
                proxy_pass http://192.168.110.161:9001;
            }
          }
      }
      stream {
            upstream ssh {
                server 192.168.110.161:22;
                }
            server { 
                    listen 9000;
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

    networking.firewall.allowedTCPPorts = [ 10000 ];
  };
}
