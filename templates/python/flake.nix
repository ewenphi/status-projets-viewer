{
  description = "remplir";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      mylib = {
        fmt = pkgs.writeShellApplication {
          name = "fmt";
          text = ''
            nixpkgs-fmt .
            black .
          '';
        };
      };
    in {
      formatter.${pkgs.system} = pkgs.nixpkgs-fmt;

      devShells.${pkgs.system}.default = pkgs.mkShell {
        packages = [
          pkgs.python3
          pkgs.python312Packages.matplotlib
          pkgs.python312Packages.black
          pkgs.pyright
          pkgs.python312Packages.jedi-language-server
          pkgs.ruff-lsp
          pkgs.pylyzer
          pkgs.python312Packages.pylsp-mypy
          pkgs.basedpyright

          pkgs.nixpkgs-fmt
          mylib.fmt
        ];

        shellHook = ''
          echo "shell remplir"
        '';
      };
    };
}
