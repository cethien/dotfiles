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

    services.mako.settings."app-name=Slack" = {
      default-timeout = 0;
      border-color = "#4a154b";
    };

    wayland.windowManager.hyprland = {
      modals."slack" = {
        binds = [
          ", XF86Mail"
          "SUPER, F12"
        ];
        terminal = false;
        exec = "slack";
      };

      settings = {
        exec-once = mkIf cfg.autostart ["[silent] [workspace special:slack] slack -u"];
      };
    };
  };
}
