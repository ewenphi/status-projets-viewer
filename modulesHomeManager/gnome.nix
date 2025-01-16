{ config
, pkgs
, lib
, ...
}: {
  options = {
    gnome.enable = lib.mkEnableOption "enable gnome customisation module";
  };

  config = lib.mkIf config.gnome.enable {
    home.packages = [
      pkgs.nethogs
      pkgs.iw
      pkgs.iotop
      pkgs.gtop
    ];
    programs.gnome-shell = {
      enable = true;
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      extensions = [
        { package = pkgs.gnomeExtensions.cronomix; }

        { package = pkgs.gnomeExtensions.paperwm; }
        { package = pkgs.gnomeExtensions.auto-screen-brightness; }
        { package = pkgs.gnomeExtensions.auto-power-profile; }

        { package = pkgs.gnomeExtensions.appindicator; }
        { package = pkgs.gnomeExtensions.thinkpad-battery-threshold; }
        { package = pkgs.gnomeExtensions.systemd-status; }
        { package = pkgs.gnomeExtensions.github-actions; }

        { package = pkgs.gnomeExtensions.open-bar; }
        { package = pkgs.gnomeExtensions.just-perfection; }
        { package = pkgs.gnomeExtensions.another-window-session-manager; }
        { package = pkgs.gnomeExtensions.astra-monitor; }

      ];
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          favorite-apps = [ "firefox.desktop" "kitty.desktop" "nemo.desktop" "thunderbird.desktop" ];
        };

        "org/gnome/desktop/interface" = {
          clock-show-seconds = true;
          clock-show-weekday = true;
        };

        "org/gnome/shell/keybindings" = {
          toggle-quick-settings = [ "<Super>m" ];
        };

        "org/gnome/shell/extensions/paperwm/keybindings" = {
          toggle-maximise-width = [ "<Super>s" ];
          toggle-top-bar = [ "<Super>b" ];
          toggle-position-bar = [ ];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          email = [ "<Super><Shift>t" ];
          www = [ "<Super>f" ];
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Deconnexion";
          command = "gnome-session-quit --logout --no-prompt";
          binding = "<Ctrl><Super><Alt>d";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Mise en veille";
          command = "systemctl suspend";
          binding = "<Ctrl><Super><Alt>v";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          name = "Mise en veille";
          command = "gnome-session-quit --reboot";
          binding = "<Ctrl><Super><Alt>r";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          name = "Eteindre";
          command = "gnome-session-quit --power-off";
          binding = "<Ctrl><Super><Alt>e";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          name = "Terminal kitty";
          command = "kitty";
          binding = "<Ctrl><Alt>t";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
          name = "Fichiers (nemo)";
          command = "nemo";
          binding = "<Super>e";
        };

        "org/gnome/shell/extensions/auto-power-profile" = {
          threshold = 99;
          bat = "power-saver";
        };

        "org/gnome/shell/extensions/just-perfection" = {
          startup-status = 0;
          clock-menu-position = 2;
        };


      };
    };
  };
}

