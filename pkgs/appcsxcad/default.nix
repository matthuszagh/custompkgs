{ fetchFromGitHub, stdenv, cmake
, csxcad, qcsxcad, hdf5, vtk, qt4, fparser, tinyxml, cgal, boost
}:

stdenv.mkDerivation rec {
  name = "appcsxcad-${version}";
  version = "0.2.2";
  # src = /home/matt/src/openEMS-Project/AppCSXCAD;
  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "AppCSXCAD";
    rev = "v${version}";
    sha256 = "05xj7xmbsdhasycyyax1m742sjzwp2vzndwiaz966a2pam2fxi9c";
  };

  buildInputs = [
    csxcad
    qcsxcad
    hdf5
    vtk
    qt4
    fparser
    tinyxml
    cgal
    boost
  ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = {
    description = "Minimal Application using the QCSXCAD library";
    homepage = https://github.com/thliebig/AppCSXCAD;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthuszagh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
