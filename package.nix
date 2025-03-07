{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  crane ? (builtins.getFlake "github:ipetkov/crane"),
}:
let
  craneLib = crane.mkLib pkgs;

  commonArgsCrane = {
    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./src
        ./Cargo.toml
        ./Cargo.lock
      ];
    };
    strictDeps = true;
    nativeBuildInputs = [
      pkgs.pkg-config
    ];
    buildInputs = [
      pkgs.openssl
      pkgs.flake-checker
    ];
  };

  status-projets-viewer-crate = craneLib.buildPackage (
    commonArgsCrane
    // {
      cargoArtifacts = craneLib.buildDepsOnly commonArgsCrane;
    }
  );
in
status-projets-viewer-crate
