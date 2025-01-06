{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.programs.spotify;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf (cfg.enable && isHyprland) {
    home.packages = with pkgs; [
      playerctl
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "[workspace 11 silent] spotify"
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
