{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = with pkgs.hyprlandPlugins; [
        hyprspace
      ];

      settings = {
        bind = [
          "$mainMod, TAB, overview:toggle"
        ];
      };
    };
  };
}
