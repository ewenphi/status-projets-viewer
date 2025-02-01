{ config, lib, ... }: {
  options = {
    programs-head-oneliners.enable =
      lib.mkEnableOption "enable programs head oneliners module";
  };
  config = lib.mkIf config.programs-head-oneliners.enable { };
}
