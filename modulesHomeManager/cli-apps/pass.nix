{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    pass.enable = lib.mkEnableOption "enable pass module";
  };

  config = lib.mkIf config.pass.enable {
    programs.password-store.enable = true;
    programs.password-store.package = pkgs.pass.withExtensions (
      ext: with ext; [
        pass-audit
        pass-import
        pass-update
        pass-otp
        pass-checkup
      ]
    );
  };
}
