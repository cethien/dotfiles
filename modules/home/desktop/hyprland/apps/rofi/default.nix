{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    catppuccin.rofi.enable = false;

    programs.rofi = {
      enable = true;
      # package = pkgs.rofi-wayland;

      cycle = true;

      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
        rofi-top
      ];

      extraConfig = {
        modi = "drun,ssh,emoji,calc,top";
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
        "SUPER SHIFT, P, exec, rofi -show top"
      ];

      windowrulev2 = [
        "stayfocused, class:^(Rofi)$"
      ];
    };
  };
}
