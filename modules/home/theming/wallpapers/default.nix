{ lib, config, ... }:

{
  options.theming.wallpapers.enable = lib.mkEnableOption "Include wallpapers";

  config = lib.mkIf config.theming.wallpapers.enable {
    home.file."${config.home.homeDirectory}/Pictures/wallpapers".source = ./wallpapers;
  };
}
