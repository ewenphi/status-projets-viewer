{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    git.enable = lib.mkEnableOption "enable git module";
  };

  config = lib.mkIf config.git.enable {
    home.packages = [
      pkgs.gitoxide
      pkgs.lazygit
    ];

    programs.git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
      ];
      difftastic = {
        enable = true;
        color = "always";
      };
    };
  };
}
