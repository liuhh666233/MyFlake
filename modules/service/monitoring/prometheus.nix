{ config, pkgs, ... }: {
  config = {
    services.prometheus = {
      enable = true;
      port = 9001;
      # Add node exporter
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
        systemd = {
          enable = true;
          port = 9558;
        };
      };
      # configure Prometheus to read metrics from this exporter
      scrapeConfigs = [{
        job_name = "chrysalis";
        static_configs = [{
          targets = [
            "127.0.0.1:${
              toString config.services.prometheus.exporters.node.port
            }"
            "127.0.0.1:${
              toString config.services.prometheus.exporters.systemd.port
            }"

          ];
        }];
      }];

    };
  };
}
