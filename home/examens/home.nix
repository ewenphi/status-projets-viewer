{ pkgs, lib, ... }:
let myTexLive = pkgs.texliveFull.withPackages (ps: with ps; [ movie15 ]);
in {
  imports = [ ../../modulesHomeManager ];

  home-common.enable = true;
  home = {
    packages = [
      pkgs.texmaker

      pkgs.libreoffice-fresh
      pkgs.kdePackages.ark
      pkgs.mate.atril
      myTexLive
      pkgs.openssh
      pkgs.libqalculate
      pkgs.typst
      pkgs.neovim
    ];
    #disabled
    username = pkgs.lib.mkForce "examens";
    homeDirectory = pkgs.lib.mkForce "/home/examens/";
  };
  cli-apps.enable = lib.mkForce false;
  zsh.enable = true;
}
