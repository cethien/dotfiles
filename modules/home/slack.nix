{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.slack;

  slack-password-fix = pkgs.symlinkJoin {
    name = "slack-password-fix";
    paths = [pkgs-unstable.slack];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/slack --add-flags "--password-store=basic"
    '';
  };

  autostartFile = pkgs.makeDesktopItem {
    name = "slack-autostart";
    exec = "${slack-password-fix}/bin/slack -u";
    desktopName = "Slack (Autostart)";
  };
in {
  options.programs.slack = {
    enable = mkEnableOption "slack";
    autostart = mkEnableOption "slack autostart";
  };

  config = mkIf cfg.enable {
    home.packages = [slack-password-fix];

    services.mako.settings."app-name=Slack" = {
      default-timeout = 0;
      border-color = "#4a154b";
    };

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/slack-autostart.desktop"
    ];
  };
}
