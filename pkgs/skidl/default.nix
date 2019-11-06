{ stdenv, python3Packages, fetchFromGitHub
, kicad
, kinparse
, pyspice
, pykicad
# , pillow
}:

python3Packages.buildPythonPackage rec {
  pname = "skidl";
  version = "0.0.26";

  # src = /home/matt/src/skidl;
  src = fetchFromGitHub {
    owner = "xesscorp";
    repo = "skidl";
    rev = "${version}";
    sha256 = "1iizd86pp1ws8jmaqhyxd2raw6jkzjixi78x4k3if3v6illnb3b0";
  };

  propagatedBuildInputs = (with python3Packages; [
    setuptools
    future
    kinparse
    enum34
    pyspice
    graphviz
    wxPython_4_0
    pykicad
    # pillow
  ]) ++ [
    kicad
  ];

  # patchPhase = ''
  #   export KICAD_SYMBOL_DIR=${kicad.out}/share/kicad/library
  #   echo $KICAD_SYMBOL_DIR
  # '';
  doCheck = false;

  # skidl uses KICAD_SYMBOL_DIR to find kicad libraries
  makeWrapperArgs = [
    "--set" "KICAD_SYMBOL_DIR" "${kicad.out}/share/kicad/library"
  ];

  meta = with stdenv.lib; {
    description = "SKiDL is a module that extends Python with the ability to design electronic circuits";
    homepage = "https://xesscorp.github.io/skidl/docs/_site/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
