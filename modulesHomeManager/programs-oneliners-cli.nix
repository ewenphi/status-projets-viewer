{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    programs-oneliners-cli.enable = lib.mkEnableOption "enable programs oneliners cli module";
  };

  config = lib.mkIf config.programs-oneliners-cli.enable {
    programs = {
      zellij = {
        enable = true;
        settings.theme = "tokyo-night-storm";
        enableZshIntegration = false;
      };
      taskwarrior = {
        enable = true;
        dataLocation = "$HOME/Nextcloud/task";
        package = pkgs.taskwarrior3;
      };
    };
  };
}
