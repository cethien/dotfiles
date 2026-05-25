{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.slack;
in {
  options.programs.slack.enable = lib.mkEnableOption "slack";
  options.programs.slack.autostart = lib.mkEnableOption "slack autostart";

  config = mkIf cfg.enable {
    home.packages = [pkgs.slack];

    wayland.windowManager.hyprland = {
      modals."slack" = {
        binds = ["SHIFT, XF86Mail"];
        terminal = false;
        exec = "slack";
      };

      settings = {
        exec-once = mkIf cfg.autostart ["[silent] slack -u"];
      };
    };
  };
}
