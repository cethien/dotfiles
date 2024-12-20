{ lib, config, ... }:

{
  options.user.desktop.wallpapers.enable = lib.mkEnableOption "Include wallpapers";

  config = lib.mkIf config.user.desktop.wallpapers.enable {
    home.file."/home/cethien/Pictures/wallpapers".source = ./wallpapers;
  };
}
