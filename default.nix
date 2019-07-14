{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    vtk = callPackage ./pkgs/vtk { inherit (pkgs.xorg) libX11 libXt xorgproto; };
    fparser = callPackage ./pkgs/fparser { };
    csxcad = callPackage ./pkgs/csxcad { };
    qcsxcad = callPackage ./pkgs/qcsxcad { };
    appcsxcad = callPackage ./pkgs/appcsxcad { };
    openems = callPackage ./pkgs/openems { };
  };
in self
