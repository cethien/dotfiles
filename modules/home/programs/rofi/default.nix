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
    home.packages = with pkgs; [
      rofi-power-menu
    ];

    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];
      theme = ./theme.rafi;
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, PERIOD, exec, rofi -show calc"
        ''
          SUPER, escape, exec, rofi -show power-menu -modi "power-menu:rofi-power-menu --choices=shutdown/reboot/suspend"
        ''
      ];

      windowrulev2 = [
        "stayfocused, class:^(Rofi)$"
      ];
    };
  };
}
