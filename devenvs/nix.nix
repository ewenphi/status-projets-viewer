{ pkgs, ... }:
{
  languages.nix.enable = true;

  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    statix.enable = true;
    deadnix.enable = true;
    commitizen.enable = true;
  };

  packages = [
    pkgs.nil
  ];

  enterShell = ''
    echo hello from 
  '';
}
