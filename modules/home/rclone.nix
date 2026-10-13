{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.programs.rclone;

  host = "127.0.0.1";
  port = "8080";
  apiPort = "5572";

  rcloneLauncher = pkgs.writeShellScriptBin "rclone-web-launcher" ''
    ${pkgs.xdg-utils}/bin/xdg-open "http://${host}:${port}/login?url=http://${host}:${apiPort}"
  '';
in {
  config = lib.mkIf cfg.enable {
    programs.rclone.package = pkgs-unstable.rclone;

    systemd.user.services.rclone-webui = {
      Unit = {
        Description = "Rclone Web UI";
        After = ["network.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs-unstable.rclone}/bin/rclone gui --no-auth --addr ${host}:${port} --api-addr ${host}:${apiPort}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };

    xdg.desktopEntries."rclone-web-ui" = {
      name = "rclone web ui";
      genericName = "rclone";
      exec = "${rcloneLauncher}/bin/rclone-web-launcher";
      icon = "rclone";
      type = "Application";
      categories = ["Utility"];
    };
  };
}
