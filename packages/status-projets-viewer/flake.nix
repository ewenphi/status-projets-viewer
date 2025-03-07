{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mydevenvs.url = "github:yvaniak/mydevenvs";
    mydevenvs.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
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
        {
          pkgs,
          config,
          ...
        }:
        {
          packages.default = pkgs.callPackage ./default.nix { inherit (inputs) crane; };

          devenv.shells.default = {
            packages =
              config.packages.default.nativeBuildInputs
              ++ config.packages.default.buildInputs
              ++ config.devenv.shells.default.git-hooks.enabledPackages;

            mydevenvs = {

              rust.enable = true;
              nix = {
                enable = true;
                flake.enable = true;
                check.enable = true;
                check.package = pkgs.hello;
              };
              tools.just = {
                enable = true;
                pre-commit.enable = true;
                check.enable = true;
              };
              global.enterTest.enable = false;
            };
            enterShell = ''
              echo "shell for status-projets-viewer"
            '';
          };
        };
      flake = {
      };
      debug = true;
    };
}
