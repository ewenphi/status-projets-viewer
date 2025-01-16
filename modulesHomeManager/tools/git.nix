{ pkgs, lib, config, ... }: {
  options = {
    git.enable = lib.mkEnableOption "enable git module";
  };

  config = lib.mkIf config.git.enable {
    home.packages = [
      pkgs.git
      pkgs.gitoxide
    ];

    programs.git.difftastic = {
      enable = true;
      color = "always";
    };
  };
}
