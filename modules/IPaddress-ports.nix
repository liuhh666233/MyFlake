{
  sisyphus = "192.168.110.207";
  bishop = "192.168.110.161";
  publicAddress = "182.151.40.8";
  awsBackupAddress =
    "ec2-161-189-97-38.cn-northwest-1.compute.amazonaws.com.cn";
  localhost = "0.0.0.0";

  # Bishop
  mysqlTcpPort = 3306;
  dataPipelineMonitorWebPort = 5000;
  redisTcpPort = 6379;
  sipuixImporterServerPort = 7001;
  jupyterWebServerPort = 7777;
  clickhouseHttpPort = 9001;
  clickhouseTcpPort = 9005;
  bishopNginxServerPort = 10000;
  jsyArchiverWebPort = 15000;
  jsyImporterWebPort = 15010;
  deriverWebPort = 15020;
  windImporterWebPort = 15040;
  suntimeImporterWebPort = 15080;
  butlerTcpPort = 16001;

  # Sisyphus
  hydraWebPort = 3000;
  nixServerPort = 3001;
  grafanaWebPort = 2342;
  prometheusWebPort = 5001;
  nodeExporterWebPort = 5002;
  systemdExporterWebPort = 5003;
  sqlExporterWebPort = 5004;
  relayAlertWebPort = 5005;
  butlerExporterWebPort = 5006;
  clickhouseExporterWebPort = 5007;
  lokiHttpPort = 3100;
  lokiGrpcPort = 9096;
  promtailHttpPort = 28183;
  sisyphusNginxServerPort = 10001;
}
