{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.rofi.enable {
    programs.rofi = {
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        show-icons = true;
      };
      modes = ["drun"];
    };

    home.file.".config/rofi/grid.rasi".source = ./grid.rasi;

    xdg.desktopEntries.rofi-freerdp = {
      name = "FreeRDP";
      comment = "Launch the FreeRDP menu via Rofi";
      exec = "${pkgs.writeShellScriptBin "rofi-freerdp" (builtins.readFile ./rofi-freerdp.sh)}/bin/rofi-freerdp";
      icon = "remote-desktop";
      terminal = false;
      type = "Application";
      categories = ["Network" "Utility"];
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, Space, exec, rofi -show drun"

        "SUPER, Tab, exec, rofi -show window"

        ''SUPER, escape, exec, rofi -show power-menu -modi "power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu --choices=suspend/reboot/shutdown"''

        "SUPER, M, exec, ${
          pkgs.writeShellScriptBin "rofi-audio" (builtins.readFile ./rofi-audio.sh)
        }/bin/rofi-audio"

        "SUPER, W, exec, ${
          pkgs.writeShellScriptBin "rofi-websearch" (builtins.readFile ./rofi-websearch.sh)
        }/bin/rofi-websearch"

        "SUPER, N, exec, ${
          pkgs.writeShellScriptBin "rofi-net" (builtins.readFile ./rofi-net.sh)
        }/bin/rofi-net"

        "SUPER, B, exec, ${pkgs.rofi-bluetooth}/bin/rofi-bluetooth"

        "SUPER, R, exec, ${
          pkgs.writeShellScriptBin "rofi-screenrecord" (builtins.readFile ./rofi-screenrecord.sh)
        }/bin/rofi-screenrecord"

        ''SUPER, PERIOD, exec, ${pkgs.rofimoji} --hidden-description --selector-args="-theme ~/.config/rofi/grid.rasi"''
      ];
    };
  };
}
