{ config, pkgs, ... }:
let
  static-ip-config = import ../../../static-ip-config.nix;
  regex-components = import ./regex-component.nix;

  promtail-config = pkgs.callPackage ./config {
    lokiHttpAddress = static-ip-config.localhost;
    lokiHttpPort = 3100;
    httpPort = 28183;
    excludeServicesRegex = regex-components.excludeServicesRegex;
    jsyArchiverLogRegex = regex-components.logRegexSet.jsy-archiver;
    windImporterLogRegex = regex-components.logRegexSet.jsy-importer;
    jsyImporterLogRegex = regex-components.logRegexSet.wind-importer;
  };
in {
  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${promtail-config}/promtail.yaml
      '';
    };
  };
}
