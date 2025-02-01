{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixpkgs-godot4-1.url =
      "github:nixos/nixpkgs?rev=459104f841356362bfb9ce1c788c1d42846b2454";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url =
        "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #perso nix
    auto-updater = {
      # url = "git+https://codeberg.org/Yvaniak/auto-updater";
      url = "path:./packages/auto-updater";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        configNvf = {
          options = { };
          config = import ./packages/nvf.nix { inherit pkgs; };
        };

        customNeovim = inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ configNvf ];
        };
      in {
        formatter = treefmtEval.config.build.wrapper;

        checks = { formatting = treefmtEval.config.build.check self; };

        packages.myNvim = customNeovim.neovim;
      }) // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system:
        let
          overlay = _final: _prev: {
            inherit (inputs.nixpkgs-godot4-1.legacyPackages.${pkgs.system})
              godot_4;
            nix-search = inputs.nix-search.packages.${pkgs.system}.default;
            auto-updater = inputs.auto-updater.packages.${pkgs.system}.default;
          };
          pkgs = import nixpkgs {
            inherit system;

            config = { allowUnfree = true; };

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
        in {
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

          templates = {
            rust = {
              path = ./templates/rust;
              description = "my rust template";
              welcomeText = "rust template initialized";
            };

            js = {
              path = ./templates/js;
              description = "my js template";
              welcomeText = "js template initialized";
            };

            python = {
              path = ./templates/python;
              description = "my python template";
              welcomeText = "python template initialized";
            };
          };
        });
}
