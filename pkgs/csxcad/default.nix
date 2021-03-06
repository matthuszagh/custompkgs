{ fetchFromGitHub, stdenv, cmake
, fparser, tinyxml, hdf5, cgal, vtk, boost
}:

stdenv.mkDerivation rec {
  pname = "csxcad";
  version = "master";
  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "55899d0fc3dbfc2eb3ec60af9783925926e661a9";
    sha256 = "18h10575c8k0bx7l0pk5ksqfc1vvnsg98br2987y8x4jmrw2jy50";
  };

  patches = [ ./searchPath.patch ];

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

  meta = with stdenv.lib; {
    description = "A C++ library to describe geometrical objects";
    homepage = https://github.com/thliebig/CSXCAD;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
