{ config
, lib
, inputs
, ...
}: {
  options = {
    home-common.enable = lib.mkEnableOption "enable home-common bundle module";
  };

  config = lib.mkIf config.home-common.enable {
    #custom modules
    cli-apps.enable = true;
    tools.enable = true;
    base.enable = true;
    programs-oneliners-cli.enable = true;
    nvf.enable = true;
    #fin custom modules

    targets.genericLinux.enable = true;
    home = {

      username = "ewen";
      homeDirectory = "/home/ewen";

      stateVersion = "23.11";

      # The home.packages option allows you to install Nix packages into your
      # environment.
      packages = [
        #devenv
        #import (fetchTarball {
        #  url="https://install.devenv.sh/latest";
        #  sha256 = "sha256:0wj5455mk0kgm4vnvqia6x4qhkwwf3cn07pdsd4wmfdbp9rxr44a";}).default

        # # Adds the 'hello' command to your environment. It prints a friendly
        # # "Hello, world!" when run.
        # pkgs.hello

        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
      ];

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. If you don't want to manage your shell through Home
      # Manager then you have to manually source 'hm-session-vars.sh' located at
      # either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/ewen/etc/profile.d/hm-session-vars.sh
      #
      sessionVariables = {
        EDITOR = "nvim";
      };
    };
    programs.home-manager.enable = true;

    nix.registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
