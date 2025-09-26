{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault;
in {
  config = {
    services.restic = {
      enable = mkDefault true;
      # TODO:
      # backups = {};
    };

    sops.secrets."rclone/drive/token" = {};

    programs.rclone = {
      enable = mkDefault true;
      remotes = {
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

    services.syncthing = {
      enable = mkDefault true;
      settings = {
        options.urAccepted = -1;
        devices = {
          "surface-7-pro" = {
            id = "V72GLPB-OSTVXDA-364YAUW-UV4V6QD-ASF57FV-BKSYYUP-ISOFUX6-GORIBQD";
          };
          "xiaomi-15" = {
            id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
          };
          "hp-430-g7" = {
            id = "QQAPR6F-HZE4V4M-JTSTNLO-6SBXQFY-FTEH4ZQ-QDBFFXX-SL5SQOM-LD5XXQU";
          };
        };
      };
    };
  };
}
