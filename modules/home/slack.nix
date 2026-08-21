{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.slack;

  autostartFile = pkgs.makeDesktopItem {
    name = "slack-autostart";
    exec = "slack -u";
    desktopName = "Slack (Autostart)";
  };
in {
  options.programs.slack = {
    enable = mkEnableOption "slack";
    autostart = mkEnableOption "slack autostart";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs-unstable.slack];

    services.mako.settings."app-name=Slack" = {
      default-timeout = 0;
      border-color = "#4a154b";
    };

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/slack-autostart.desktop"
    ];
  };
}
