{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  config = mkIf config.programs.rofi.enable {
    home.packages = with pkgs; [
      rofimoji

      rofi-power-menu
      rofi-bluetooth

      libnotify
      (writeShellScriptBin "rofi-wifi-menu" (builtins.readFile ./rofi-wifi-menu.sh))

      wl-screenrec
      (writeShellScriptBin "rofi-wl-screenrec" (builtins.readFile ./rofi-wl-screenrec.sh))
    ];

    programs.rofi = {
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
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
        "SUPER, N, exec, rofi-wifi-menu"
        "SUPER, B, exec, rofi-bluetooth"
        "SUPER, R, exec, rofi-wl-screenrec"
        ''SUPER, PERIOD, exec, rofimoji --hidden-description --selector-args="-theme ~/.config/rofi/grid.rasi"''
      ];
    };
  };
}
