{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "/home/cethien/Pictures/wallpapers/drippy-smiley.jpg"
          "/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];

        wallpaper = [
          "DP-1,/home/cethien/Pictures/wallpapers/drippy-smiley.jpg"
          "DP-2,/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];
      };
    };
  };
}
