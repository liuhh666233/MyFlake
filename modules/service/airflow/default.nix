{ config, pkgs, lib, ... }:
let
  cfg = config.services.airflow;
  airflow-config =
    pkgs.callPackage ./airflow-config { airflowHome = cfg.airflowHome; };
in {

  options.services.airflow = with lib; {

    enable = mkEnableOption "Relay alert messages of airflow.";

    user = mkOption {
      type = types.str;
      default = "lxb";
      description = "The user under which airflow service runs";
      example = "lxb";
    };

    webServerPort = mkOption {
      type = types.port;
      default = 9123;
      description = ''
        This is the port that the user accesss the web server.
      '';
      example = 9123;
    };

    airflowHome = mkOption {
      type = types.path;
      default = "/home/lxb/airflow";
      description = "The path of airflow config.";
      example = "/home/lxb/airflow";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.airflow-webserver = {
      description = "Start airflow webserver.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [ ! -d "${cfg.airflowHome}" ]; then
          mkdir ${cfg.airflowHome}
        fi
        cp -rf ${airflow-config}/* ${cfg.airflowHome}

        if [ ! -d "${cfg.airflowHome}/dags" ]; then
          mkdir ${cfg.airflowHome}/dags
        fi
        cp -rf ${pkgs.airflow-dags}/* ${cfg.airflowHome}/dags
      '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Restart = "always";
        RestartSec = "10s";
        ExecStart = "${pkgs.airflow-python}/bin/airflow webserver --port ${
            toString cfg.webServerPort
          } ";
      };
      environment = { AIRFLOW_HOME = cfg.airflowHome; };
    };

    systemd.services.airflow-scheduler = {
      description = "Start airflow scheduler.";
      after = [ "airflow-webserver.services" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Restart = "always";
        RestartSec = "10s";
        ExecStart = "${pkgs.airflow-python}/bin/airflow scheduler";
      };
      environment = { AIRFLOW_HOME = cfg.airflowHome; };
      path = [ pkgs.bash ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.webServerPort ];
  };
}
