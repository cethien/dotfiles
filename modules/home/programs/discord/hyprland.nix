{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfgApp = config.deeznuts.programs.discord;
  cfg = config.deeznuts.programs.hyprland.programs.discord;
  isHyprland = config.deeznuts.programs.hyprland.enable;
  enabled = isHyprland && cfgApp.enable != false;
in
{
  options.deeznuts.programs.hyprland.programs.discord = {
    autostart = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable autostart";
      };
      workspace = mkOption {
        type = types.int;
        default = 3;
        description = "Workspace for autostart";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart.enable [
        "[workspace ${toString cfg.autostart.workspace} silent] discord --start-minimized"
      ];
    };
  };
}
