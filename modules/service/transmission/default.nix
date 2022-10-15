{ config, pkgs, ... }: {

  services.transmission = {
    enable = true;
    settings = {
      rpc-port = 9091;
      download-dir = "/var/lib/wonder/warehouse/Shares/Public/downloads";
      incomplete-dir = "/var/lib/wonder/warehouse/Shares/Public/.incomplete";
      incomplete-dir-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      rpc-bind-address = "0.0.0.0";
    };
  };
  networking.firewall.allowedTCPPorts = [
    9091 # wsdd
  ];
}
