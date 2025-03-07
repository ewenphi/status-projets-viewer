{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    custom.enable = lib.mkEnableOption "install my packages module";
  };

  config = lib.mkIf config.custom.enable {
    home.packages = [
      pkgs.filesort
      (pkgs.callPackage ./../../packages/auto-updater { })
      (pkgs.callPackage ./../../packages/status-projets-viewer { inherit (inputs) crane; })
      pkgs.flake-checker
    ];
  };
}
