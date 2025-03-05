{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  options = {
    codium.enable = lib.mkEnableOption "enable codium with extensions module";
  };

  config = lib.mkIf config.gnome.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = [
          #javascript (javascript et typescript built-in)
          pkgs.vscode-extensions.esbenp.prettier-vscode
          pkgs.vscode-extensions.dbaeumer.vscode-eslint
          inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx.biomejs.biome

          #python
          pkgs.vscode-extensions.ms-python.python
          pkgs.vscode-extensions.ms-python.pylint
          pkgs.vscode-extensions.ms-python.black-formatter
          pkgs.vscode-extensions.charliermarsh.ruff

          #go
          pkgs.vscode-extensions.golang.go

          #rust
          pkgs.vscode-extensions.rust-lang.rust-analyzer

          #c
          pkgs.vscode-extensions.llvm-vs-code-extensions.vscode-clangd

          #csharp
          inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx.neikeq.godot-csharp-vscode
          pkgs.vscode-extensions.ms-dotnettools.csharp
          inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace.ms-dotnettools.csdevkit
          inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace.ms-dotnettools.vscode-dotnet-pack

          #nix
          pkgs.vscode-extensions.jnoortheen.nix-ide
          inputs.nix-vscode-extensions.extensions.x86_64-linux.open-vsx.pinage404.nix-extension-pack

          #yaml
          pkgs.vscode-extensions.redhat.vscode-yaml

          #comments
          pkgs.vscode-extensions.gruntfuggly.todo-tree

          #vim keybinds
          pkgs.vscode-extensions.vscodevim.vim

          #github
          pkgs.vscode-extensions.github.vscode-github-actions
          pkgs.vscode-extensions.github.vscode-pull-request-github

          #deps
          inputs.nix-vscode-extensions.extensions.${pkgs.system}.open-vsx.fill-labs.dependi

          #editorconfig
          inputs.nix-vscode-extensions.extensions.x86_64-linux.open-vsx.editorconfig.editorconfig

          #lazygit
          inputs.nix-vscode-extensions.extensions.x86_64-linux.open-vsx.chaitanyashahare.lazygit

          #meson
          pkgs.vscode-extensions.mesonbuild.mesonbuild
        ];
        userSettings = {
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;

          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
          "nix.formatterPath" = "nixfmt";

          "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
          "typescript.inlayHints.parameterNames.enabled" = "all";
          "typescript.inlayHints.parameterTypes.enabled" = true;
          "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
          "typescript.inlayHints.variableTypes.enabled" = true;

          "go.inlayHints.assignVariableTypes" = true;
          "go.inlayHints.compositeLiteralFields" = true;
          "go.inlayHints.compositeLiteralTypes" = true;
          "go.inlayHints.constantValues" = true;
          "go.inlayHints.functionTypeParameters" = true;
          "go.inlayHints.parameterNames" = true;
          "go.inlayHints.rangeVariableTypes" = true;

        };
      };
    };
  };
}
