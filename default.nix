{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> {
    inherit system;
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = rec {
    fparser = callPackage ./pkgs/fparser { };
    csxcad = callPackage ./pkgs/csxcad { };
    qcsxcad = callPackage ./pkgs/qcsxcad { };
    appcsxcad = callPackage ./pkgs/appcsxcad { };
    openems = callPackage ./pkgs/openems { };
    # primerun = callPackage ./pkgs/primerun { };
    hyp2mat = callPackage ./pkgs/hyp2mat { };
    gl2ps = callPackage ./pkgs/gl2ps { };

    brainworkshop = callPackage ./pkgs/brainworkshop { };
    kibom = callPackage ./pkgs/kibom { };
    avbin = callPackage ./pkgs/avbin { };
    libav = callPackage ./pkgs/libav { };
    pt1230 = callPackage ./pkgs/pt1230 { };

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

    # texlive overrides
    latexmk.pkgs = [(callPackage ./pkgs/latexmk { })];
    circuitikz.pkgs = [(callPackage ./pkgs/circuitikz { })];

    # emacs packages
    emacs-wrapped = callPackage ./pkgs/emacs-wrapped { };
    org-recoll = callPackage ./pkgs/org-recoll { };
    layers = callPackage ./pkgs/layers { };
    justify-kp = callPackage ./pkgs/justify-kp { };

    # python packages
    # pylibftdi = pkgs.callPackage ./pkgs/pylibftdi { };

    # personal packages
    ebase = callPackage ./pkgs/ebase { };
    libdigital = pkgs.callPackage ./pkgs/libdigital { };
    bitmanip = pkgs.callPackage ./pkgs/bitmanip { };
  };
in self
