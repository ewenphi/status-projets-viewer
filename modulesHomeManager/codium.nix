{ config, pkgs, lib, ... }: {
  options = {
    codium.enable = lib.mkEnableOption "enable codium with extensions module";
  };

  config = lib.mkIf config.gnome.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = [
        #javascript (javascript et typescript built-in)
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.dbaeumer.vscode-eslint

        #nix
        pkgs.vscode-extensions.jnoortheen.nix-ide

        #yaml
        pkgs.vscode-extensions.redhat.vscode-yaml

        #comments
        pkgs.vscode-extensions.gruntfuggly.todo-tree

        #vim keybinds
        pkgs.vscode-extensions.vscodevim.vim

        #github
        pkgs.vscode-extensions.github.vscode-github-actions
        pkgs.vscode-extensions.github.vscode-pull-request-github
      ];
      userSettings = {
        "nix.autoSave" = "on";
        "nix.enableLanguageServer" = "true";
      };
    };
  };
}
