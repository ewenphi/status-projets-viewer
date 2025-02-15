{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    #packages only
    nix-search = {
      url = "github:diamondburned/nix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    #perso nix
    auto-updater = {
      # url = "git+https://codeberg.org/Yvaniak/auto-updater";
      url = "path:./packages/auto-updater";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    filesort = {
      url = "github:yvaniak/filesort";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #fin perso
  };

  outputs =
    { nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };

        configNvf = {
          options = { };
          config = import ./packages/nvf.nix { inherit pkgs; };
        };

        customNeovim = inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ configNvf ];
        };
      in
      {
        packages.myNvim = customNeovim.neovim;
      }
    )
    // inputs.flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        overlay = _final: _prev: {
          nix-search = inputs.nix-search.packages.${pkgs.system}.default;
          auto-updater = inputs.auto-updater.packages.${pkgs.system}.default;
          filesort = inputs.filesort.packages.${pkgs.system}.default;
        };
        pkgs = import inputs.nixpkgs {
          inherit system;

          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "dotnet-sdk-6.0.428"
            ];
          };

          overlays = [ overlay ];
        };

        configNvf = {
          options = { };
          config = import ./packages/nvf.nix { inherit pkgs; };
        };

        customNeovim = inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ configNvf ];
        };
      in
      {
        homeConfigurations = {
          ewen = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              inherit system;
              inherit customNeovim;
            };

            modules = [ ./home/ewen/home.nix ];

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
          };

          examens = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              inherit system;
            };

            modules = [ ./home/examens/home.nix ];
          };

          serveur = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };

            modules = [ ./home/serveur/home.nix ];
          };
        };
      }
    );
}
