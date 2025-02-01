{
  description = ""; # à remplir

  inputs = { flake-utils = { url = "github:numtide/flake-utils"; }; };

  outputs = { nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        mylib = {
          update = pkgs.writeShellApplication {
            name = "update";
            text = ''
              pnpm up
            '';
          };
          install_deps = pkgs.writeShellApplication {
            name = "install_deps";
            text = ''
              pnpm i
            '';
          };
        };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells = {
          default = pkgs.mkShell {
            packages = [
              pkgs.nodejs_latest
              pkgs.nodePackages.pnpm
              pkgs.nodePackages.vscode-langservers-extracted
              pkgs.tailwindcss-language-server
              pkgs.stylelint-lsp
              pkgs.typescript-language-server
              pkgs.deno

              mylib.update
              mylib.install_deps
            ];

            shellHook = ''
              echo "shell pour " #à remplir
            '';
          };
        };
      });
}
