{
  pkgs ? import <nixpkgs> { },
  ...
}:

pkgs.stdenv.mkDerivation {
  pname = "auto-updater";
  version = "0.1.2.2.1";
  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
    pkgs.curlMinimal
    pkgs.jq
  ];
  buildInputs = [
    pkgs.git
    pkgs.nh
    pkgs.curlMinimal
    pkgs.jq
  ];
  src = ./src;
  #meson
  mesonBuildType = "custom";
}
