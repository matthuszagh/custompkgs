{ fetchFromGitHub, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "fparser-${version}";
  version = "4.5.1";
  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "fparser";
    rev = "master";
    sha256 = "0wayml1mlyi922gp6am3fsidhzsilziksdn5kbnpcln01h8555ad";
  };

  buildInputs = [
    cmake
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C++ Library for Evaluating Mathematical Functions";
    homepage = https://github.com/thliebig/fparser;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
