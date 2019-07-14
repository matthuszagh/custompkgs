{ fetchFromGitHub, stdenv, cmake
, fparser, tinyxml, hdf5, cgal, vtk, boost
}:

stdenv.mkDerivation rec {
  name = "csxcad-${version}";
  version = "0.6.2";
  # src = /home/matt/src/openEMS-Project/CSXCAD;
  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "v${version}";
    sha256 = "0xc8r0c2a3bhczvi84q43pv93j1v2q9a9jfbg4fqi2q99p9k147y";
  };

  patches = [./searchpath.patch ];

  buildInputs = [
    cgal
    vtk
    boost
    fparser
    tinyxml
    hdf5
  ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = {
    description = "A C++ library to describe geometrical objects";
    homepage = https://github.com/thliebig/CSXCAD;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
