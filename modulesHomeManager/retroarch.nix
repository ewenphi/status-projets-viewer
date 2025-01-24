{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    retroarch.enable = lib.mkEnableOption "enable retroarch module";
  };

  config = lib.mkIf config.retroarch.enable {
    home.packages = [
      (
        pkgs.retroarch.withCores (
          _cores: [
            # pkgs.libretro.snes9x
            # pkgs.libretro.nestopia
            # pkgs.libretro.sameboy
            pkgs.libretro.flycast
          ]
        )
      )
    ];
  };
}
