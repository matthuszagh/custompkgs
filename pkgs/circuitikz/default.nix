{ stdenv, fetchFromGitHub, texlive }:

stdenv.mkDerivation rec {
  version = "v1.0.0-pre1";
  pname = "circuitikz";
  name = "${pname}-${version}";
  tlType = "run";

  src = fetchFromGitHub {
    owner = "circuitikz";
    repo = "circuitikz";
    rev = version;
    sha256 = "14cfn2x36w5ksygra0rbgj9vshq9r5gl7fsn5x9aw7s0y3wvri6q";
  };

  dontBuild = true;

  installPhase = "
    mkdir -p $out/tex/latex
    cp tex/* $out/tex/latex/
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
