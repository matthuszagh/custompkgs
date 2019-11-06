{ stdenv, fetchFromGitHub, texlive }:

stdenv.mkDerivation rec {
  version = "v0.9.5";
  pname = "circuitikz";
  name = "${pname}-${version}";
  tlType = "run";

  src = fetchFromGitHub {
    owner = "circuitikz";
    repo = "circuitikz";
    rev = version;
    sha256 = "0li53hbs3di1kh1bg4hm7xmp3n1ic3liifhch9cfp2hkr38qqba9";
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
