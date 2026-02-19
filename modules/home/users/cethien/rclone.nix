{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.rclone.enable {
    sops.secrets."rclone_gdrive_token" = {
      sopsFile = ./secrets.yaml;
    };
    programs.rclone.remotes."gdrive" = {
      config = {
        type = "drive";
        scope = "drive";
      };
      secrets.token = config.sops.secrets."rclone_gdrive_token".path;

      mounts = {
        "" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/GDrive";
          options = {
            dir-cache-time = "5000h";
            poll-interval = "10s";
            umask = "002";
            user-agent = "desktop";
          };
        };
      };
    };
  };
}
