{
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    comma.enable = lib.mkEnableOption "enable comma module with nix-index-database";
  };

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  config = lib.mkIf config.pass.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
