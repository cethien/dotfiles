{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./hyprland
    ./hyprpaper
    ./rofi
    ./waybar
  ];

  options.deeznuts.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland desktop";
  };

  config = mkIf cfg.enable {
    services.mako.enable = true;
    services.playerctld.enable = true;
  };
}
