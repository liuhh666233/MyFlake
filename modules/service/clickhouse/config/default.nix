{ stdenv, clickhouseRoot, clickhouseListenTcpPort, clickhouseListenHttpPort, clickhouseListenMysqlPort }:

stdenv.mkDerivation {
  name = "deployable-clickhouse-config";

  src = ./.;

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp $src/config.xml $out
    cp $src/users.xml $out
    substituteInPlace $out/config.xml \
        --replace "{%CLICKHOUSE_ROOT%}" "${clickhouseRoot}"
    substituteInPlace $out/config.xml \
        --replace "{%CLICKHOUSE_TCP_PORT%}" "${toString clickhouseListenTcpPort}"
    substituteInPlace $out/config.xml \
        --replace "{%CLICKHOUSE_HTTP_PORT%}" "${toString clickhouseListenHttpPort}"
    substituteInPlace $out/config.xml \
        --replace "{%CLICKHOUSE_MYSQL_PORT%}" "${toString clickhouseListenMysqlPort}"
  '';
}
