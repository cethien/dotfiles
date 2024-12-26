{ lib, config, ... }:

{
  options.deeznuts.theming.wallpapers.enable = lib.mkEnableOption "Include wallpapers";

  config = lib.mkIf config.deeznuts.theming.wallpapers.enable {
    home.file."${config.home.homeDirectory}/Pictures/wallpapers".source = ./wallpapers;
  };
}
