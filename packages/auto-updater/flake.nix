{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mydevenvs.url = "github:yvaniak/mydevenvs";
    mydevenvs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.mydevenvs.flakeModule
        inputs.mydevenvs.devenv
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, self', ... }:
        {
          packages.default = pkgs.callPackage ./. { };
          devenv.shells.default = {
            mydevenvs = {
              c.enable = true;
              c.meson.enable = true;
              nix = {
                enable = true;
                flake.enable = true;
                check.enable = true;
                check.package = self'.packages.default;
              };
              tools.just = {
                enable = true;
                check.enable = true;
                pre-commit.enable = true;
              };
            };

            packages = self'.packages.default.buildInputs ++ self'.packages.default.nativeBuildInputs;

            enterShell = ''
              echo "shell for auto-updater"
            '';
          };
        };
      flake = {
      };
      debug = true;
    };
}
