{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.discord;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
  enabled = cfg.enable || (isHyprland && cfg.enable != false);
in
{
  options.deeznuts.programs.discord = {
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "discord autostart";
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart [
        "discord --start-minimized"
      ];
    };
  };
}
