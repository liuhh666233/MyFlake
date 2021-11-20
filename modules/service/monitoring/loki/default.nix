{ config, pkgs, ... }:
let
  static-ip-config = import ../../../IPaddress-ports.nix;

  loki-config = pkgs.callPackage ./config {
    lokiLocalhost = static-ip-config.localhost;
    lokiDataPath = "/var/lib/wonder/loki";
    httpPort = 3100;
    grpcPort = 9096;
  };
in {
  services.loki = {
    enable = true;
    configFile = "${loki-config}/loki-local-config.yaml";
  };
}
