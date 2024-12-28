{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.theming.wallpapers;
in
{
  options.deeznuts.theming.wallpapers = {
    enable = mkEnableOption "Enable wallpapers";
  };

  config = mkIf cfg.enable {
    home.file."~/Pictures/wallpapers".source = ./wallpapers;
  };
}
