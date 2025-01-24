{
  lib,
  config,
  ...
}: {
  #nix-direnv to auto nix develop
  options = {
    direnv.enable = lib.mkEnableOption "enable direnv module";
  };

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };
  };
}
