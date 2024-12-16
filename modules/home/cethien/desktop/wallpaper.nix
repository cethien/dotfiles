{ lib, config, ... }:

{
  options.user.desktop.wallpaper.enable = lib.mkEnableOption "Include wallpaper";

  config = lib.mkIf config.user.desktop.wallpaper.enable {
    home.file."/home/cethien/Pictures/wallpapers/default.jpg".source = ./assets/wallpaper.jpg;
  };
}
