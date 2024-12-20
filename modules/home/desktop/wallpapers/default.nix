{ lib, config, ... }:

{
  options.desktop.wallpapers.enable = lib.mkEnableOption "Include wallpapers";

  config = lib.mkIf config.desktop.wallpapers.enable {
    home.file."${config.home.homeDirectory}/Pictures/wallpapers".source = ./wallpapers;
  };
}
