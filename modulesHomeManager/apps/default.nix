{
  lib,
  config,
  ...
}: {
  imports = [
    ./nextcloud.nix
  ];

  options = {
    apps.enable = lib.mkEnableOption "enable apps bundle";
  };

  config = lib.mkIf config.apps.enable {
    nextcloud.enable = true;
  };
}
