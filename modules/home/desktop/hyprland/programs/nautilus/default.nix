{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  enabled = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enabled {
    home.packages = with pkgs; [
      nautilus
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, E, exec, nautilus"
      ];
    };
  };
}
