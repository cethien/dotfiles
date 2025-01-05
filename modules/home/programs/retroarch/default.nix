{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.retroarch;
in
{
  options.deeznuts.programs.retroarch = {
    enable = mkEnableOption "Enable retroarch";
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
          mgba #GB / GBC / GBA
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
