{ config, pkgs, lib, ... }:
let
  cfg = config.services.jsy-archiver;

  TIMEPATTERN = "([[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2})";

in {

  options.services.jsy-archiver = with lib; {

    warehousePath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse";
      description = "The path of warehouse.";
      example = "/var/lib/wonder/warehouse";
    };

    tickTradeStartTime = mkOption {
      type = types.strMatching TIMEPATTERN;
      default = "21:00:00";
      description = "The time of downloading the tick trade data.";
      example = "21:00:00";
    };

    tickSliceStartTime = mkOption {
      type = types.strMatching TIMEPATTERN;
      default = "21:00:00";
      description = "The time of downloading the tick slice data.";
      example = "21:00:00";
    };

    minbarStartTime = mkOption {
      type = types.strMatching TIMEPATTERN;
      default = "21:00:00";
      description = "The time of downloading the minbar data.";
      example = "21:00:00";
    };

    dailyStartTime = mkOption {
      type = types.strMatching TIMEPATTERN;
      default = "21:00:00";
      description = "The time of downloading the daily data.";
      example = "21:00:00";
    };

    webServerPort = mkOption {
      type = types.port;
      default = 15000;
      description = ''
        This is the port that the user accesss the web server.
      '';
      example = 15000;
    };

    enableDiscovery = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable discovery of server.
      '';
      example = true;
    };
  };

  config = {

    systemd.services.jsy-archiver = {
      description = "Start jsy archiver.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "lxb";
        Restart = "always";
        RestartSec = "10s";
      };

      script = ''
        ${pkgs.warehouse}/bin/jsy_archiver_app \
        -a ${pkgs.dp-webui}/webapp \
        -t '${cfg.tickTradeStartTime} tick_trade' \
        -t '${cfg.tickSliceStartTime} tick_slice' \
        -t '${cfg.minbarStartTime} minbar' \
        -i ${cfg.warehousePath} \
        -d ${toString (cfg.enableDiscovery)} \
        --port ${toString (cfg.webServerPort)}
      '';
    };

    networking.firewall.allowedTCPPorts = [ cfg.webServerPort ];
  };
}
