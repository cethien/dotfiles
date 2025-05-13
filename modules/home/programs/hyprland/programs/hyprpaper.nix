{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.hyprpaper;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.hyprpaper.enable = mkEnableOption "hyprpaper";

  config = mkIf enabled {
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
