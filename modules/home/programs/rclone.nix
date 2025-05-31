{config, ...}: {
  config = {
    sops.secrets."rclone/drive/token" = {};

    programs.rclone.enable = true;
    programs.rclone.remotes = {
      "gdrive" = {
        mounts = {
          "" = {
            enable = true;
            mountPoint = "${config.home.homeDirectory}/mnt/GDrive";
            options = {
              dir-cache-time = "5000h";
              poll-interval = "10s";
              umask = "002";
              user-agent = "desktop";
            };
          };
        };

        config = {
          type = "drive";
          scope = "drive";
        };
        secrets = {
          token = config.sops.secrets."rclone/drive/token".path;
        };
      };
    };
  };
}
