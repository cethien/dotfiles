{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.programs.zen;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf (cfg.enable && isHyprland) {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "[workspace 6 silent] zen"
      ];
    };
  };
}
