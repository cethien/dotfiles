{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.discord;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.discord = {
    hyprlandWorkspace = mkOption {
      type = types.int;
      default = 3;
      description = "Workspace to use for discord";
    };
  };

  config = mkIf (cfg.enable && isHyprland) {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "[workspace ${toString cfg.hyprlandWorkspace} silent] vesktop --start-minimized"
      ];
    };
  };
}
