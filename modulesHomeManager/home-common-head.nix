{ lib, config, ... }:
{
  options = {
    home-common-head.enable = lib.mkEnableOption "enable home-common-head bundle module";
  };

  config = lib.mkIf config.home-common-head.enable {
    home-common.enable = true;

    graphique.enable = true;
    apps.enable = true;

    programs-head-oneliners.enable = true;

    gnome.enable = true;

    stylix-module.enable = true;

    codium.enable = true;

    custom.enable = true;
  };
}
