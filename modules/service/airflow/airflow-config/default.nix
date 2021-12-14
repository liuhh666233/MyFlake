{ stdenv, airflowHome }:

stdenv.mkDerivation {
  name = "deployable-airflow-config";

  src = ./.;

  unpackPhase = ":";
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out
    cp $src/airflow.cfg $out
    cp $src/webserver_config.py $out
    substituteInPlace $out/airflow.cfg \
        --replace "{%AIRFLOW_HOME%}" "${airflowHome}"
  '';
}
