{ stdenv, fetchFromGitHub
, csxcad, fparser, tinyxml, hdf5, vtk, boost, cgal, zlib, cmake, octave, gl2ps
, withQcsxcad ? true
, withMPI ? true
, withHyp2mat ? true
, qcsxcad ? null
, openmpi ? null
, hyp2mat ? null
}:

assert withQcsxcad -> qcsxcad != null;
assert withMPI -> openmpi != null;
assert withHyp2mat -> hyp2mat != null;

stdenv.mkDerivation rec {
  name = "openems-${version}";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "ffcf5ee0a64b2c64be306a3154405b0f13d5fbba";
    sha256 = "1c8wlv0caxlhpicji26k93i9797f1alz6g2kc3fi18id0b0bjgha";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = stdenv.lib.optionals withMPI [ "-DWITH_MPI=ON" ];

  buildInputs = [
    fparser
    tinyxml
    hdf5
    vtk
    boost
    cgal
    zlib
    csxcad
    (octave.override { inherit gl2ps hdf5; })
    (if withQcsxcad then qcsxcad else null)
    (if withMPI then (openmpi.override { enableCpp = true; }) else null)
    (if withHyp2mat then hyp2mat else null)
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

  meta = with stdenv.lib; {
    description = "Open Source Electromagnetic Field Solver";
    homepage = http://openems.de/index.php/Main_Page.html;
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}
