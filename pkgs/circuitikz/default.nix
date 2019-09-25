{ stdenv, fetchFromGitHub, texlive }:

stdenv.mkDerivation rec {
  version = "v0.9.4";
  pname = "circuitikz";
  name = "${pname}-${version}";
  tlType = "run";

  src = fetchFromGitHub {
    owner = "circuitikz";
    repo = "circuitikz";
    rev = version;
    sha256 = "16sxsz19i6vwnf3v4c5mlvy96zzazv2q1ahcw0sbrdb2wi7hgcx4";
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
