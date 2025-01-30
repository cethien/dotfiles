{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfgApp = config.deeznuts.programs.spotify;
  cfg = config.deeznuts.desktop.hyprland.programs.spotify;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
  enabled = isHyprland && cfgApp.enable != false;
in
{
  options.deeznuts.desktop.hyprland.programs.spotify = {
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
    home.packages = with pkgs; [
      playerctl
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart.enable [
        "[workspace ${toString cfg.autostart.workspace} silent] spotify"
      ];

      "$spotifyctl" = "playerctl --player=spotify";

      bindl = [
        ", XF86AudioRaiseVolume, exec, $spotifyctl volume 0.05+"
        ", XF86AudioLowerVolume, exec, $spotifyctl volume 0.05-"

        ", XF86AudioNext, exec, $spotifyctl next"
        ", XF86AudioPrev, exec, $spotifyctl previous"
        ", XF86AudioPlay, exec, $spotifyctl play-pause"
        ", XF86AudioPause, exec, $spotifyctl play-pause"
      ];
    };
  };
}
