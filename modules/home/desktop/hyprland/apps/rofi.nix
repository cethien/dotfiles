{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
