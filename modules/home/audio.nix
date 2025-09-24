{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.audio;
in {
  options.deeznuts.audio = {
    enable = mkEnableOption "audio related programs";
  };

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."org.pulseaudio.pavucontrol" = "";
    home.packages = with pkgs; [
      pavucontrol
      qpwgraph
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

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, N, exec, hypr_wiremix"
      ];
    };
  };
}
