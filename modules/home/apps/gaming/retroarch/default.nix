{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.gaming.retroarch;
in
{
  options.deeznuts.apps.gaming.retroarch = {
    enable = mkEnableOption "Enable retroarch";
  };

  config = mkIf cfg.enable {
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
