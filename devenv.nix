{ inputs, ... }:
{
  imports = [ inputs.devenvs.devenvModules.devenvs.default ];
  nix.enable = true;
  nix.flake.enable = true;

  enterShell = ''
    echo hello from home-config
  '';
}
