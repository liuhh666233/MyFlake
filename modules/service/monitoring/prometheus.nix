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
        redis = {
          enable = true;
          port = 9121;
        };
        sql = {
          enable = false;
          port = 9237;
          configuration = {
            jobs = {
              windFinancialStatementExceptionData = {
                interval = "1h";
                connections = [ "clickhouse://bishop:9000?database=wind" ];
                queries = {
                  queryNetIncomeParent = {
                    help = "Examine exceptional wind FinancialStatement data.";
                    labels = [ "ReportDate" "PeriodYear" "StockId" ];
                    query =
                      "SELECT toString(toDate(fs.ReportDate)) as `ReportDate`, toString(fs.PeriodYear) as `PeriodYear`,toString(fs.StockId) as `StockId`,fs.NetIncomeParent from wind.FinancialStatement fs where fs.NetIncomeParent > 1000000000000 order by fs.NetIncomeParent desc;";
                    values = [ "NetIncomeParent" ];
                  };
                };
              };
            };
          };
        };
      };
      # configure Prometheus to read metrics from this exporter
      scrapeConfigs = [
        {
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
        {
          job_name = "test";
          static_configs = [{ targets = [ "127.0.0.1:${toString 5000}" ]; }];
        }
        {
          job_name = "redis_exporter";
          static_configs = [{
            targets = [
              "127.0.0.1:${
                toString config.services.prometheus.exporters.redis.port
              }"
            ];
          }];
        }
      ];
    };
  };
}
