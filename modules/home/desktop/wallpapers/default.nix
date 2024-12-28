{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop;
in
{
  config = mkIf (cfg.gnome.enable || cfg.plasma6.enable || cfg.hyprland.enable) {
    home.file."Pictures/wallpapers".source = ./wallpapers;
  };
}
