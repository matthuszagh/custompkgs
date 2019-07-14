{ fetchFromGitHub, stdenv, cmake
, csxcad, tinyxml, vtk, qt4
}:

stdenv.mkDerivation rec {
  name = "qcsxcad-${version}";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "QCSXCAD";
    rev = "v${version}";
    sha256 = "1l77xr1skf9rrd0pwdw0wcz8a3qzwnn9vz7613j2w5xwakagiglj";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCSXCAD_ROOT_DIR=${csxcad}"
    "-DENABLE_RPATH=OFF"
  ];

  buildInputs = [
    csxcad
    tinyxml
    vtk
    qt4
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Qt-GUI for CSXCAD";
    homepage = https://github.com/thliebig/QCSXCAD;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.linux;
  };
}
