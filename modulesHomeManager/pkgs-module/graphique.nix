{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  myTexLive = pkgs.texliveFull.withPackages (ps: with ps; [ movie15 ]);
in
{
  options = {
    graphique.enable = lib.mkEnableOption "install graphic packages module";
  };

  config = lib.mkIf config.graphique.enable {
    nixGL = {
      inherit (inputs.nixgl) packages;
      defaultWrapper = "mesa";
      installScripts = [ "mesa" ];
    };

    home.packages = [
      pkgs.discord
      pkgs.bugdom
      pkgs.dolphin-emu

      pkgs.jellyfin-web
      pkgs.freeplane
      pkgs.libreoffice-fresh
      pkgs.mpv
      pkgs.nemo-with-extensions
      pkgs.thunderbird
      pkgs.distrobox
      pkgs.caprine-bin
      pkgs.whatsapp-for-linux
      pkgs.gimp
      pkgs.krita

      pkgs.kdePackages.ark
      pkgs.baobab
      pkgs.gparted
      pkgs.eog

      pkgs.rofi-pass-wayland
      pkgs.nix-search
      pkgs.comma

      pkgs.mate.atril
      myTexLive
      pkgs.quickemu
      pkgs.anytype
      pkgs.pdfpc

      pkgs.podman
      pkgs.nixpacks

      (config.lib.nixGL.wrap pkgs.kitty)
      (config.lib.nixGL.wrap pkgs.firefox)
      (config.lib.nixGL.wrap pkgs.godot_4-mono)
    ];
  };
}
