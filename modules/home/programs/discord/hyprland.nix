{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.discord;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf (cfg.enable && isHyprland) {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "discord --start-minimized"
      ];
    };
  };
}
