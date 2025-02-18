{ inputs, ... }:
{
  imports = [ inputs.devenvs.devenvModules.devenvs.default ];
  nix.enable = true;

  enterShell = ''
    echo hello from home-config
  '';

  enterTest = "nix build .#homeConfigurations.ewen.activationPackage";
}
