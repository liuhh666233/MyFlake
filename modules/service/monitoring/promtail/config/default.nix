{ stdenv, lokiHttpAddress, lokiHttpPort, httpPort, excludeServicesRegex, jsyArchiverLogRegex, windImporterLogRegex, jsyImporterLogRegex, ...}:

stdenv.mkDerivation {
  name = "promtail-config";

  src = ./.;

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp $src/promtail.yaml $out
    substituteInPlace $out/promtail.yaml \
        --replace "{%LOKI_LISTEN_ADDRESS%}" "${lokiHttpAddress}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%LOKI_LISTEN_PORT%}" "${ toString lokiHttpPort}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%HTTPPORT%}" "${toString httpPort}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%EXCLUDE_SERVICES%}" "${excludeServicesRegex}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%JSY_ARCHIVER_LOG_REGEX%}" "${jsyArchiverLogRegex}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%WIND_IMPORTER_LOG_REGEX%}" "${windImporterLogRegex}"
    substituteInPlace $out/promtail.yaml \
        --replace "{%JSY_IMPORTER_LOG_REGEX%}" "${jsyImporterLogRegex}"
  '';
}
