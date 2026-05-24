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
    wayland.windowManager.hyprland.modals."wiremix".bind = "SUPER SHIFT, A";
  };
}
