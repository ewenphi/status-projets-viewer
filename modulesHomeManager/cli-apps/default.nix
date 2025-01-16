{ lib
, config
, ...
}: {
  imports = [
    ./zsh.nix
    ./pass.nix
    ./gpg.nix
  ];

  options = {
    cli-apps.enable = lib.mkEnableOption "enable cli-apps bundle";
  };

  config = lib.mkIf config.cli-apps.enable {
    zsh.enable = true;
    pass.enable = true;
    gpg.enable = true;
  };
}
