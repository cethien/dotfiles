{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.rofi.enable {
    home.packages = with pkgs; [
      rofimoji
      rofi-power-menu
      rofi-bluetooth

      libnotify
      (writeShellScriptBin "rofi-wifi" (builtins.readFile ./rofi-wifi.sh))
      playerctl
      (writeShellScriptBin "rofi-audio" (builtins.readFile ./rofi-audio.sh))
      wl-screenrec
      (writeShellScriptBin "rofi-screenrecord" (builtins.readFile ./rofi-screenrecord.sh))
    ];
    programs.rofi = {
      terminal = "kitty";
      extraConfig = {
        show-icons = true;
      };
      modes = ["drun" "run"];
    };

    home.file.".config/rofi/grid.rasi".source = ./grid.rasi;

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, Tab, exec, rofi -show window"
        ''SUPER, escape, exec, rofi -show power-menu -modi "power-menu:rofi-power-menu --choices=suspend/reboot/shutdown"''
        "SUPER, M, exec, rofi-audio"
        "SUPER, N, exec, rofi-wifi"
        "SUPER, B, exec, rofi-bluetooth"
        "SUPER, R, exec, rofi-screenrecord"
        ''SUPER, PERIOD, exec, rofimoji --hidden-description --selector-args="-theme ~/.config/rofi/grid.rasi"''
      ];
    };
  };
}
