{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = with pkgs; [
      rofimoji

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
      terminal = "\${pkgs.kitty}/bin/kitty";
      plugins = with pkgs; [
        rofi-calc
      ];
      extraConfig = {
        show-icons = true;
      };
      cycle = false;
    };

    home.file.".config/rofi/grid.rasi".source = ./grid.rasi;

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, r, exec, rofi -show run"
        ''SUPER, escape, exec, rofi -show power-menu -modi "power-menu:rofi-power-menu"''
        "SUPER, N, exec, rofi-wifi-menu"
        "SUPER, B, exec, rofi-bluetooth"
        "SUPER, M, exec, rofi-playerctl"
        "SUPER, comma, exec, rofi -show calc -modi calc -no-show-match -no-sort -no-bold -no-history"
        ''SUPER, PERIOD, exec, rofimoji --hidden-description --selector-args="-theme ~/.config/rofi/grid.rasi"''
      ];
    };
  };
}
