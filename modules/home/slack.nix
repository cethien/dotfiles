{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.slack;
in {
  options.programs.slack = {
    enable = mkEnableOption "slack";
    autostart = mkEnableOption "slack autostart";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.slack];

    services.mako.settings."app-name=Slack" = {
      default-timeout = 0;
      border-color = "#4a154b";
    };

    xdg.configFile."autostart/slack.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Name=Slack
        Comment=Slack Desktop
        Exec=slack -u
        Icon=slack
        Terminal=false
        Type=Application
        Categories=Network;InstantMessaging;
      '';
    };
  };
}
