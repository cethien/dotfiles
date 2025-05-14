{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.rofi;
  enable = cfg.enable;
in
{
  options.deeznuts.programs.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf enable {
    home.packages = with pkgs; [
      rofi-power-menu
      rofi-bluetooth

      libnotify
      (writeShellScriptBin "rofi-wifi-menu" (builtins.readFile ./rofi-wifi-menu.sh))

      playerctl
      (writeShellScriptBin "rofi-playerctl" (builtins.readFile ./rofi-playerctl.sh))
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = ./theme.rafi;
      plugins = with pkgs;[
        rofi-calc
        rofi-emoji
      ];
      extraConfig = {
        show-icons = true;
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, PERIOD, exec, rofi -show calc -modi calc -no-show-match -no-sort -no-bold -no-history"
        ''
          SUPER, escape, exec, rofi -show power-menu -modi "power-menu:rofi-power-menu --choices=shutdown/reboot/suspend"
        ''
        "SUPER, B, exec, rofi-bluetooth"
        "SUPER, N, exec, rofi-wifi-menu"
        "SUPER, M, exec, rofi-playerctl"
      ];
    };
  };
}
