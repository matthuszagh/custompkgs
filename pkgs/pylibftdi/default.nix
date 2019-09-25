{ buildPythonPackage, fetchurl, stdenv, setuptools }:

buildPythonPackage rec {
  pname = "pylibftdi";
  version = "0.17.0";

  src = fetchurl {
    url = https://bitbucket.org/codedstructure/pylibftdi/get/0.17.0.tar.bz2;
    sha256 = "0zpv9crwvx92g4c5yrpk83i840x4l53j1y4inwf5dfmww3r1r9zw";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  format = "other";

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/codedstructure/pylibftdi/src/default/;
    description = "Minimal pythonic wrapper to Intra2net's libftdi driver for FTDI's USB devices";
    license = licenses.mit;
  };
}
