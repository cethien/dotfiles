{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.rofi;
  enable = cfg.enable || config.deeznuts.programs.hyprland.enable;
in
{
  options.deeznuts.programs.rofi = {
    enable = mkEnableOption "Enable rofi";
  };

  config = mkIf enable {
    programs.rofi = {
      enable = true;
      # package = pkgs.rofi-wayland;

      cycle = true;

      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
      ];

      extraConfig = {
        modi = "drun,ssh,emoji,calc";
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
      ];

      windowrulev2 = [
        "stayfocused, class:^(Rofi)$"
      ];
    };
  };
}
