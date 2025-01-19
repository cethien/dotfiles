{ lib, config, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.zen;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.zen = {
    hyprlandWorkspace = mkOption {
      type = types.int;
      default = 1;
      description = "Workspace to use for zen";
    };
  };

  config = mkIf (cfg.enable && isHyprland) {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "[workspace ${toString cfg.hyprlandWorkspace} silent] zen"
      ];
    };
  };
}
