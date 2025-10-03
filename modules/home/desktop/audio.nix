{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.desktop.isEnabled {
    home.packages = with pkgs; [
      wiremix
    ];

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, N, exec, ${
        (pkgs.cethien.hyprland.writeTermLaunchScriptBin "wiremix").bin
      }"
    ];
  };
}
