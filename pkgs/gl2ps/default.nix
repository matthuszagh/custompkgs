{ stdenv, fetchgit, cmake, libGL, libpng, zlib, tetex }:

stdenv.mkDerivation rec {
  name = "gl2ps-${version}";
  version = "1.4.1";

  src = fetchgit {
    url = http://gitlab.onelab.info/gl2ps/gl2ps.git;
    sha256 = "1d1636gnqa9f73mkl1azdpm6kbqzrg3lwh3f787vcc9f2rhn1f9p";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libGL
    libpng
    zlib
    tetex
  ];

  enableParallelBuilding = true;

  meta = {
    description = "OpenGL to PostScript printing library";
    homepage = http://geuz.org/gl2ps/;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [ matthuszagh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
