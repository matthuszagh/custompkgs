{ stdenv, fetchFromGitHub,
  csxcad, fparser, tinyxml, hdf5, vtk, boost, cgal, zlib, cmake
, octave
}:

stdenv.mkDerivation rec {
  name = "openems-${version}";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "v${version}";
    sha256 = "041iy784500f7msvf0xc0y2s8f6mc1dcgbanx11010p3vmk9js3m";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fparser
    tinyxml
    hdf5
    vtk
    boost
    cgal
    zlib
    csxcad
    octave
  ];

  postFixup = ''
    substituteInPlace $out/share/openEMS/matlab/setup.m \
      --replace /usr/lib ${hdf5}/lib \
      --replace /usr/include ${hdf5}/include

    ${octave}/bin/mkoctfile -L${hdf5}/lib -I${hdf5}/include \
      -lhdf5 $out/share/openEMS/matlab/h5readatt_octave.cc \
      -o $out/share/openEMS/matlab/h5readatt_octave.oct
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source Electromagnetic Field Solver";
    homepage = http://openems.de/index.php/Main_Page.html;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
