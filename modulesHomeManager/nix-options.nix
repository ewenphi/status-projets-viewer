{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options = {
    nix-options.enable = lib.mkEnableOption "enable my nix options module";
  };

  config = lib.mkIf config.nix-options.enable {
    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
        auto-optimise-store = true
      '';
      package = pkgs.nix;
      gc.automatic = true;
    };
  };
}
