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
        sql = {
          enable = true;
          port = 9237;
          configuration = {
            jobs = {
              windFinancialStatementExceptionData = {
                interval = "1h";
                connections = [ "clickhouse://hua:9000?database=wind" ];
                queries = {
                  queryNetIncomeParent = {
                    help = "Examine exceptional wind FinancialStatement data.";
                    labels = [ "Date" "StockId" ];
                    query =
                      "SELECT toString(toDate(fs.ReportDate)) as `Date`,toString(fs.StockId),fs.NetIncomeParent from wind.FinancialStatement fs where fs.NetIncomeParent > 100000000000 order by fs.NetIncomeParent desc;";
                    values = [ "NetIncomeParent" ];
                  };
                };
              };
            };
          };
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
            "127.0.0.1:${
              toString config.services.prometheus.exporters.sql.port
            }"

          ];
        }];
      }
      # Add test python exporter
      # {
      #   job_name = "test";
      #   static_configs = [{ targets = [ "127.0.0.1:${toString 8000}" ]; }];
      # }
        ];
    };
  };
}
