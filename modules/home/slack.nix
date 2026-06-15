{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.lib.deeznuts.hyprland) mkExecBind;
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
  };
}
