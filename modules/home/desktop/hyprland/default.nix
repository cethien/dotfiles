{ lib, config, pkgs, ... }:

{
  imports = [
    ./hyprland
    ./hyprpaper
    ./rofi
    ./waybar
  ];

  options.deeznuts.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    services.mako.enable = true;
    services.playerctld.enable = true;
  };
}
