{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.waybar;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.waybar.enable = mkEnableOption "waybar";

  config = mkIf enabled {
    programs.waybar = {
      enable = true;
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
      ];
    };
  };
}
