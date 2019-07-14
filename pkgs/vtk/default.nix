{ stdenv, fetchurl, cmake, libGLU_combined, libX11, xorgproto, libXt
, python, gdal, ffmpeg, boost, postgresql, mysql57, unixODBC, openmpi
, qt4
}:

with stdenv.lib;

let
  majorVersion = "7.0";
  minorVersion = "0";
  version = "${majorVersion}.${minorVersion}";
in

stdenv.mkDerivation rec {
  name = "vtk-${version}";
  src = fetchurl {
    url = "${meta.homepage}files/release/${majorVersion}/VTK-${version}.tar.gz";
    sha256 = "1hrjxkcvs3ap0bdhk90vymz5pgvxmg7q6sz8ab3wsyddbshr1abq";
  };

  buildInputs = [ openmpi unixODBC mysql57 postgresql ffmpeg boost gdal python cmake libGLU_combined libX11 xorgproto libXt qt4 ];

  preBuild = ''
    export LD_LIBRARY_PATH="$(pwd)/lib";
  '';

  # Shared libraries don't work, because of rpath troubles with the current
  # nixpkgs camke approach. It wants to call a binary at build time, just
  # built and requiring one of the shared objects.
  # At least, we use -fPIC for other packages to be able to use this in shared
  # objects.
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-fPIC" "-DCMAKE_CXX_FLAGS=-fPIC" "-DModule_vtkGUISupportQt:BOOL=ON" ];

  enableParallelBuilding = true;

  meta = {
    description = "Open source libraries for 3D computer graphics, image processing and visualization";
    homepage = http://www.vtk.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
