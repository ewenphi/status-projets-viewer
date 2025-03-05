{
  pkgs ? import <nixpkgs> { },
  lib,
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "auto-updater";
  version = "0.1.2.2.1";
  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
  ];
  buildInputs = [
    pkgs.git
    pkgs.nh
    pkgs.curlMinimal
    pkgs.jq
    pkgs.flake-checker
  ];
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.union ./src ./meson.build;
  };
}
