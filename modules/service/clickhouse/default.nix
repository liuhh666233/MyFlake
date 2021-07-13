{ config, pkgs, lib, ... }:

let cfg = config.services.clickhouse-server;

    clickhouse-config = pkgs.callPackage ./config {
        clickhouseRoot = cfg.clickhouseRoot;
        clickhouseListenTcpPort = cfg.tcpPort;
        clickhouseListenHttpPort = cfg.httpPort;
        clickhouseListenMysqlPort = cfg.mysqlPort;
    };

in {

    options.services.clickhouse-server = with lib; {
        clickhouseRoot = mkOption {
            type = types.str;
            default = "/var/lib/wonder/warehouse/clickhouse";
            description = "Root directory of clickhouse data";
            example = "/var/lib/wonder/warehouse/clickhouse";
        };

        tcpPort = mkOption {
            type = types.port;
            default = 9000;
            description = ''
                TCP Port.
                The official clickhouse-client and clickhouse python library uses this port.
            '';
            example = 9000;
        };

        httpPort = mkOption {
            type = types.port;
            default = 8123;
            description = ''
                HTTP Port.
                The 3rd party clickhouse-cli tool uses this port.
            '';
            example = 8123;
        };

        mysqlPort = mkOption {
            type = types.port;
            default = 9004;
            description = "The clickhouse listen mysql port";
            example = 9004;
        };
    };

    config = {
        environment.systemPackages = [
            pkgs.clickhouse
        ];

        systemd.services.clickhouse-server = {
            description = "Start clickhouse-serve.";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig= {
                Type = "simple";
                Restart = "always";
                RestartSec= "10s";
            };
            script = ''
                ${pkgs.clickhouse}/bin/clickhouse-server \
                --config-file=${clickhouse-config}/config.xml start
            '';
        };

        networking.firewall.allowedTCPPorts = [
        cfg.tcpPort
        cfg.httpPort
        ];
    };
}
