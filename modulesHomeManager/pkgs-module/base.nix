{ pkgs, lib, config, customNeovim, ... }: {
  options = {
    base.enable = lib.mkEnableOption "install base packages module";
  };

  config = lib.mkIf config.base.enable {
    home.packages = [
      pkgs.openssh
      pkgs.neovim
      pkgs.nh
      pkgs.nvd
      pkgs.nix-output-monitor
      pkgs.arp-scan
      pkgs.cloc
      pkgs.stow
      pkgs.libqalculate
      pkgs.htop
      pkgs.fastfetch
      pkgs.typst
      pkgs.icdiff
      pkgs.ngrok
      pkgs.wget
      pkgs.brightnessctl
      pkgs.ripgrep
      pkgs.caligula
      pkgs.tealdeer
      pkgs.wikiman
      pkgs.broot
      pkgs.process-compose
      pkgs.btop
      pkgs.cava
      pkgs.unzip
      pkgs.wl-clipboard
      pkgs.auto-updater
      customNeovim.neovim
    ];
  };
}
