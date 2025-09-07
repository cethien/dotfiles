{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.storage;
in {
  options.deeznuts.storage = {
    enable = mkEnableOption "storage apps";

    restic.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable restic";
    };

    rclone.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable rclone";
    };

    syncthing.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable syncthing";
    };
  };

  config = mkIf cfg.enable {
    services.restic = {
      enable = cfg.restic.enable;
      # TODO
      # backups = {};
    };

    sops.secrets."rclone/drive/token" = {};

    programs.rclone = {
      enable = cfg.rclone.enable;
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
      enable = cfg.syncthing.enable;
      settings = {
        options.urAccepted = -1;
        devices = {
          "hp-430-g7" = {
            id = "QQAPR6F-HZE4V4M-JTSTNLO-6SBXQFY-FTEH4ZQ-QDBFFXX-SL5SQOM-LD5XXQU";
          };
          "xiaomi-15" = {
            id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
          };
        };
      };
    };
  };
}
