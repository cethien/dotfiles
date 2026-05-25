{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.wiremix;
in {
  options.programs.wiremix.enable = lib.mkEnableOption "wiremix";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wiremix
    ];

    wayland.windowManager.hyprland.modals."wiremix".binds = [
      "SUPER SHIFT, A"
      "CTRL, XF86Music"
    ];
  };
}
