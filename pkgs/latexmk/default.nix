{stdenv, fetchurl, unzip, perl, texlive}:

stdenv.mkDerivation rec {
  version = "4.65";
  pname = "latexmk";
  name = "${pname}-${version}";
  tlType = "bin";

  src = fetchurl {
    url = "http://mirrors.ctan.org/support/${pname}.zip";
    sha256 = "1nm6skqg5am6sxp7ihaqmb5fpbzdsyzijn6bgwalrwcrs8qd8abs";
  };

  buildInputs = [ unzip ];
  propagatedBuildInputs = [ perl ];

  unpackPhase = ''
    unzip $src
  '';

  dontBuild = true;

  installPhase = "
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp latexmk/latexmk.pl $out/bin/latexmk
    cp latexmk/latexmk.1 $out/share/man/man1/
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
