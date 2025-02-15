{ inputs, ... }:
{
  imports = [ inputs.devenvs.homeManagerModules.devenvs.default ];
  nix.enable = true;

  enterShell = ''
    echo hello from home-config
  '';
}
