{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.pixlator;
  extraOptions = config.wonder.baseOptions.serviceBaseOption;
in {

  options.services.pixlator = extraOptions // {
    warehousePath = mkOption {
      type = types.path;
      default = "/var/lib/wonder/warehouse";
      description = "The path of warehouse.";
      example = "/var/lib/wonder/warehouse";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.pixlator = {
      description = "Start pixlator.";
      after = cfg.dependency;
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [ ! -d "${cfg.warehousePath}" ]; then
          mkdir ${cfg.warehousePath}
        fi
      '';
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Restart = "always";
        RestartSec = "10s";
        ExecStart = ''
          ${pkgs.pixlator}/bin/pixlator
        '';
      };
      environment = {
        PORT = toString cfg.webServerPort;
        UPLOAD_DIR = "${cfg.warehousePath}/uploads";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.webServerPort ];
  };
}
