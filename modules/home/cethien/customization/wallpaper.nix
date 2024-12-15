{ lib, config, ... }:

{
  options.user.customization.wallpaper.enable = lib.mkEnableOption "Enable wallpaper";

  config = lib.mkIf config.user.customization.wallpaper.enable {
    home.file."/home/cethien/Pictures/wallpapers/default.jpg".source = ./assets/wallpaper.jpg;
  };
}
