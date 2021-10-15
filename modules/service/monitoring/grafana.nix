{ config, pkgs, ... }: {
  config = {
    services.grafana = {
      enable = true;
      package = grafana-latest;
      domain = "localhost";
      port = 2342;
      addr = "127.0.0.1";
    };
  };
}
