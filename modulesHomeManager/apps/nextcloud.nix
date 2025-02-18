{ lib, config, ... }:
{
  options = {
    nextcloud.enable = lib.mkEnableOption "enable nextcloud module";
  };

  config = lib.mkIf config.nextcloud.enable {
    services.nextcloud-client.enable = true;
  };
}
