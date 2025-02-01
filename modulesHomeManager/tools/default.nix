{ lib, config, ... }: {
  imports = [ ./direnv.nix ./git.nix ];

  options = { tools.enable = lib.mkEnableOption "enable tools bundle"; };

  config = lib.mkIf config.tools.enable {
    direnv.enable = true;
    git.enable = true;
  };
}
