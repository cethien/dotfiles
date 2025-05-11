{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.spotify;
  hyprlandCfg = config.deeznuts.programs.hyprland.programs.spotify;
  isHyprland = config.deeznuts.programs.hyprland.enable;
  enabled = isHyprland && cfg.enable != false;
in
{
  options.deeznuts.programs.hyprland.programs.spotify = {
    autostart = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "autostart spotify_player";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hyprlandCfg.autostart.enable [
        "spotify-player -d"
      ];
    };
  };
}
