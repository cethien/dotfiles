{ lib, config, pkgs, ... }:

{
  options.apps.gaming.retroarch.enable = lib.mkEnableOption "Enable retroarch";

  config = lib.mkIf config.apps.gaming.retroarch.enable {
    home.packages =
      let
        retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
          mesen #NES
          bsnes #SNES
          mgba #GB / GBC / GBA
          mupen64plus #N64
          dolphin #GC / Wii
          desmume #NDS
          citra #N3DS
        ]));
      in
      [
        retroarchWithCores
      ];
  };
}
