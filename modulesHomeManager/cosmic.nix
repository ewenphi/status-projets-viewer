{
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    cosmic.enable = lib.mkEnableOption "enable cosmic customisation module";
  };

  imports = [
    inputs.cosmic-manager.homeManagerModules.cosmic-manager
  ];

  config = lib.mkIf config.gnome.enable {
    programs = {
      cosmic-applibrary.enable = true;
      cosmic-edit.enable = true;
      cosmic-files.enable = true;
      cosmic-player.enable = true;
      cosmic-store.enable = true;
      cosmic-term.enable = true;
      cosmic-term.profiles = [
        {
          command = "bash";
          hold = false;
          is_default = true;
          name = "Default";
          syntax_theme_dark = "COSMIC Dark";
          syntax_theme_light = "COSMIC Light";
          tab_title = "Default";
          working_directory = "/home/user";
        }
        {
          command = "bash";
          hold = false;
          is_default = false;
          name = "New Profile";
          syntax_theme_dark = "Catppuccin Mocha";
          syntax_theme_light = "Catppuccin Latte";
          tab_title = "New Profile";
        }
      ];
      forecast.enable = true;
      tasks.enable = true;
    };
    wayland.desktopManager.cosmic = {
      enable = true;
      resetFiles = true;
      compositor = {
        autotile = true;
      };
    };
  };
}
