{ config, pkgs, ... }: {
  config = {
    services.grafana = {
      enable = true;
      domain = "localhost";
      port = 2342;
      addr = "127.0.0.1";
    };
  };
}
