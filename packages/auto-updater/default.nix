{
  stdenv,
  meson,
  ninja,
  pkg-config,
  curlMinimal,
  jq,
  git,
  nh,
  ...
}:

stdenv.mkDerivation {
  pname = "auto-updater";
  version = "0.1.2.2.1";
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    curlMinimal
    jq
  ];
  buildInputs = [
    git
    nh
    curlMinimal
    jq
  ];
  src = ./src;
  #meson
  mesonBuildType = "custom";
}
