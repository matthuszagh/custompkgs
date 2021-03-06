{ fetchFromGitHub, stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "ebase";
  src = /home/matt/src/ebase;

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    psycopg2
    pyusb
  ];

  format = "other";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/ebase.py $out/bin/ebase
    chmod +x $out/bin/ebase
    cp -r $src/ebase_config $out/bin/ebase_config
  '';
}
