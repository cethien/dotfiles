{ lib, config, ... }:
let
  inherit (lib) mkIf;
  enable = config.deeznuts.programs.hyprland.enable;
in
{
  config = mkIf enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = [
          "/home/cethien/Pictures/wallpapers/pixelart-mountains.png"
          "/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];

        wallpaper = [
          "DP-1,/home/cethien/Pictures/wallpapers/pixelart-mountains.png"
          "HDMI-A-1,/home/cethien/Pictures/wallpapers/drippy-smiley-solid-color.jpg"
        ];
      };
    };
  };
}
