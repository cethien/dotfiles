{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.retroarch;
in
{
  options.deeznuts.programs.retroarch = {
    enable = mkEnableOption "retroarch";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.gaming;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(com\.libretro\.RetroArch)$"
        "fullscreen, class:^(com\.libretro\.RetroArch)$"
      ];
    };

    home.packages =
      let
        retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
          mgba #GB / GBC / GBA
          dolphin #GC / Wii
          melonds #NDS
          citra #N3DS
        ]));
      in
      [
        retroarchWithCores
      ];
  };
}
