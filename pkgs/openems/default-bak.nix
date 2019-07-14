{ stdenv, fetchFromGitHub,
  csxcad, fparser, tinyxml, hdf5, vtk, boost, cgal, zlib, cmake
, octave
, appcsxcad
, qcsxcad
}:

stdenv.mkDerivation rec {
  name = "openems-${version}";
  version = "0.0.35";

  src = /home/matt/src/openEMS-Project;
  # src = fetchFromGitHub {
  #   owner = "thliebig";
  #   repo = "openEMS-Project";
  #   rev = "v${version}";
  #   sha256 = "053kmmzf3a4c40ywsmqk79fmfw5bz5r8blfwnjawdg7bcy8kbmk2";
  # };

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
    appcsxcad
    qcsxcad
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
