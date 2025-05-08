{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfgApp = config.deeznuts.programs.zen-browser;
  cfg = config.deeznuts.programs.hyprland.programs.zen-browser;
  isHyprland = config.deeznuts.programs.hyprland.enable;
  enabled = isHyprland && cfgApp.enable != false;
in
{
  options.deeznuts.programs.hyprland.programs.zen-browser = {
    autostart = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable autostart";
      };
      workspace = mkOption {
        type = types.int;
        default = 1;
        description = "Workspace for autostart";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart.enable [
        "[workspace ${toString cfg.autostart.workspace} silent] zen-beta"
      ];
    };
  };
}
