{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./settings
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      plugins = with pkgs.hyprlandPlugins; [
        hyprspace
      ];
    };
  };
}
