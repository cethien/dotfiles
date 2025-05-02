{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.decibels;
  enabled = cfg.enable || config.deeznuts.programs.hyprland.enable;
in
{
  options.deeznuts.programs.decibels = {
    enable = mkEnableOption "decibels (audio player)";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      decibels
    ];
  };
}
