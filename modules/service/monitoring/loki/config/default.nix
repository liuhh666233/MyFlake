{ stdenv, lokiLocalhost, lokiDataPath, httpPort, grpcPort }:

stdenv.mkDerivation {
  name = "loki-config";

  src = ./.;

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
      mkdir -p $out
      cp $src/loki-local-config.yaml $out
      substituteInPlace $out/loki-local-config.yaml \
          --replace "{%LOCALHOST%}" "${lokiLocalhost}"
      substituteInPlace $out/loki-local-config.yaml \
          --replace "{%DATAPATH%}" "${lokiDataPath}"
      substituteInPlace $out/loki-local-config.yaml \
          --replace "{%HTTPPORT%}" "${toString httpPort}"
    substituteInPlace $out/loki-local-config.yaml \
          --replace "{%GRPCPORT%}" "${toString grpcPort}"
  '';
}
