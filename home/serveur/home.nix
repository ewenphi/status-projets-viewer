{ lib, pkgs, ... }:
{
  imports = [ ../../modulesHomeManager ];
  home-common.enable = true;
  #desactivate pass et gpg sur le serveur
  pass.enable = lib.mkForce false;
  gpg.enable = lib.mkForce false;

  home.username = lib.mkForce "serveur";
  home.homeDirectory = lib.mkForce "/home/serveur";

  cli-apps.enable = lib.mkForce false;
  zsh.enable = true;
  stylix.enable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
}
