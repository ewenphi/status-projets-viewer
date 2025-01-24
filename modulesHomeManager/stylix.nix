{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    stylix-module.enable = lib.mkEnableOption "enable theming with stylix module";
  };

  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  config = lib.mkIf config.stylix-module.enable {
    stylix = {
      enable = true;
      image =
        pkgs.fetchFromGitHub {
          owner = "JaKooLit";
          repo = "Wallpaper-Bank";
          rev = "b23f339aed95ce89d987a65b1cfda6bac6a37c98";
          hash = "sha256-TVYMA+SudPZJQPfGqJ+iwTnqMdMIEUUidrcRazQXOuQ=";
        }
        + "/wallpapers/City-Rainy-Night.png";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      cursor = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
      };

      autoEnable = false;
      targets = {
        btop.enable = true;
        cava.enable = true;
        eog.enable = true;
        firefox.enable = true;
        firefox.firefoxGnomeTheme.enable = true;
        fzf.enable = true;
        gedit.enable = true;
        gnome.enable = true;
        gtk.enable = true;
        gtk.flatpakSupport.enable = true;
        kitty.enable = true;
        kitty.variant256Colors = true;
        lazygit.enable = true;
        neovim.enable = true;
        vscode.enable = true;
        zellij.enable = true;
      };
    };
  };
}
