{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> {
    inherit system;
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = rec {
    # TODO remove all of these when openems PR accepted
    fparser = callPackage ./pkgs/fparser { };
    csxcad = callPackage ./pkgs/csxcad { };
    qcsxcad = callPackage ./pkgs/qcsxcad { };
    appcsxcad = callPackage ./pkgs/appcsxcad { };
    openems = callPackage ./pkgs/openems { };
    openmpi = callPackage ./pkgs/openmpi { };
    hyp2mat = callPackage ./pkgs/hyp2mat { };
    gl2ps = callPackage ./pkgs/gl2ps { };
    vtk = callPackage ./pkgs/vtk {
      inherit (pkgs.xlibs) libX11 xorgproto libXt;
      inherit (pkgs.darwin) libobjc;
      inherit (pkgs.darwin.apple_sdk.libs) xpc;
      inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa CoreServices DiskArbitration
      IOKit CFNetwork Security ApplicationServices
      CoreText IOSurface ImageIO OpenGL GLUT;
    };
    vtkWithQt4 = vtk.override { qtLib = pkgs.qt4; };
    octave = callPackage ./pkgs/octave {
      libX11 = pkgs.xlibs.libX11;
    };
    cgal = callPackage ./pkgs/cgal { };

    # TODO remove when kicad PR accepted
    kicad = callPackage ./pkgs/kicad {
      inherit (pkgs.xlibs) libX11 libpthreadstubs libXdmcp lndir;
      wxGTK = pkgs.wxGTK30;
    };
    # TODO remove when skidl PR accepted
    skidl = callPackage ./pkgs/skidl {
      kinparse = kinparse;
      pyspice = pyspice;
      pykicad = pykicad;
    };
    kinparse = callPackage ./pkgs/kinparse { };
    pykicad = callPackage ./pkgs/pykicad { };
    pyspice = callPackage ./pkgs/pyspice { };

    # TODO remove when asymptote PR accepted
    asymptote = callPackage ./pkgs/asymptote {
      texLive = pkgs.texlive.combine {
        inherit (pkgs.texlive)
        scheme-small
        cm-super
        epsf
        texinfo;
      };
      gsl = pkgs.gsl_1;
    };

    # primerun = callPackage ./pkgs/primerun { };
    brainworkshop = callPackage ./pkgs/brainworkshop { };
    kibom = callPackage ./pkgs/kibom { };
    avbin = callPackage ./pkgs/avbin { };
    libav = callPackage ./pkgs/libav { };
    pt1230 = callPackage ./pkgs/pt1230 { };

    # TODO remove when vivado PR accepted
    vivado-2017-2 = callPackage ./pkgs/vivado/2017 {
      inherit (pkgs.xlibs) libSM libICE libX11 libXrender libxcb libXext libXtst libXi;
    };

    vivado-2019-1 = callPackage ./pkgs/vivado/2019 {
      inherit (pkgs.xlibs) libSM libICE libX11 libXrender libxcb libXext libXtst libXi;
    };

    xilinx-ise = callPackage ./pkgs/xilinx-ise { };

    pia-config = callPackage ./pkgs/pia { };

    nixSrc = callPackage <nixpkgs>/pkgs/tools/package-management/nixops/generic.nix (rec {
      version = "git";
      src = /home/matt/src/nix;
    });

    # clang 9 multilib
    clang_multi_9 = pkgs.wrapClangMulti pkgs.clang_9;

    # texlive overrides
    latexmk.pkgs = [(callPackage ./pkgs/latexmk { })];
    circuitikz.pkgs = [(callPackage ./pkgs/circuitikz { })];
    # luatex.pkgs = [(callPackage ./pkgs/luatex { })];

    # emacs packages
    emacs-wrapped = callPackage ./pkgs/emacs-wrapped { };
    org-recoll = callPackage ./pkgs/org-recoll { };
    layers = callPackage ./pkgs/layers { };
    justify-kp = callPackage ./pkgs/justify-kp { };

    # python packages
    cocotb = callPackage ./pkgs/cocotb { };
    # cocotb = pkgs.callPackage ./pkgs/cocotb {
    #   fetchPypi = pkgs.python3.pkgs.fetchPypi;
    #   buildPythonPackage = pkgs.python3.pkgs.buildPythonPackage;
    #   setuptools = pkgs.pythonPackages.setuptools;
    # };

    # personal packages
    ebase = callPackage ./pkgs/ebase { };
    libdigital = pkgs.callPackage ./pkgs/libdigital { cocotb = cocotb; };
    bitmanip = pkgs.callPackage ./pkgs/bitmanip { };
  };
in self
