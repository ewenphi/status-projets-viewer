{ ... }: {
  imports = [
    ./cli-apps
    ./tools
    ./pkgs-module
    ./apps
    ./programs-oneliners-cli.nix
    ./programs-head-oneliners.nix
    ./home-common.nix
    ./home-common-head.nix
    ./retroarch.nix
    ./gnome.nix
    ./nix-options.nix
    ./stylix.nix
  ];
}
