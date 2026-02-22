{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    sops.secrets.gh_token = {
      sopsFile = ./secrets.yaml;
    };

    programs.git.settings.user = {
      name = "cethien";
      email = "borislaw.sotnikow@gmx.de";
    };

    sops.secrets.rclone_gdrive_token = {
      sopsFile = ./secrets.yaml;
    };

    services.syncthing.settings = {
      options.urAccepted = -1;
      devices = {
        "tower-of-power".id = "PKVZ6VE-ENI7R5E-U4FFFH4-EEP6324-2Z3IVID-CKRQ7F3-YBX3EAI-NY5FTQD";
        "xiaomi-15".id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
        "hp-430-g7".id = "QQAPR6F-HZE4V4M-JTSTNLO-6SBXQFY-FTEH4ZQ-QDBFFXX-SL5SQOM-LD5XXQU";
      };
      folders = {
        hollow-crown = {
          id = "hollow-crown";
          path = "${config.home.homeDirectory}/hollow-crown";
          devices = ["hp-430-g7" "xiaomi-15" "tower-of-power"];
        };
        keepass = {
          id = "keepass";
          path = "${config.home.homeDirectory}/.keepass";
          devices = ["hp-430-g7" "xiaomi-15" "tower-of-power"];
        };
      };
    };

    programs.rclone.remotes."gdrive" = {
      config = {
        type = "drive";
        scope = "drive";
      };
      secrets.token = config.sops.secrets.rclone_gdrive_token.path;

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

    accounts.email.accounts = let
      email = "borislaw.sotnikow@gmx.de";
    in {
      "${email}" = rec {
        enable = lib.mkDefault false;
        thunderbird.enable = true;

        address = email;
        realName = "Borislaw Sotnikow";

        userName = email;
        smtp = {
          host = "mail.gmx.net";
          port = 587;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
        imap = {
          host = "imap.gmx.net";
          port = 993;
          tls.enable = true;
        };
        passwordCommand = "secret-tool lookup smtp-host ${smtp.host} smtp-user ${address}";
      };
    };
  };
}
