{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    custom.enable = lib.mkEnableOption "install my packages module";
  };

  config = lib.mkIf config.custom.enable {
    home.packages = [
      pkgs.filesort
      pkgs.auto-updater
    ];
  };
}
