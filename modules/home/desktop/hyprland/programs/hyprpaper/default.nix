{ lib, config, ... }:
let
  inherit (lib) mkIf;
  enable = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = [
          "/home/cethien/Pictures/wallpapers/drippy-smiley.jpg"
          "/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];

        wallpaper = [
          "DP-1,/home/cethien/Pictures/wallpapers/drippy-smiley.jpg"
          "HDMI-A-1,/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];
      };
    };
  };
}
