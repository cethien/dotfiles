{ lib, config, ... }:
{
  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg" ];

        wallpaper = [
          ",/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg"
        ];
      };
    };
  };
}
