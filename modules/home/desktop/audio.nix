{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.desktop.isEnabled {
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."org.pulseaudio.pavucontrol" = "";
    home.packages = with pkgs; [
      wiremix
      (mkIf config.wayland.windowManager.hyprland.enable (
        writeShellScriptBin "hypr_wiremix" ''
          #!/usr/bin/env bash
          hyprctl clients | grep -q 'class:.*wiremix' &&
            hyprctl dispatch focuswindow class:wiremix ||
            kitty --class wiremix -e wiremix &
        ''
      ))
    ];

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, N, exec, hypr_wiremix"
    ];
  };
}
