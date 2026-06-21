{
  pkgs,
  lib,
  config,
  ...
}: let
  name = "cethien";
  email = "borislaw.sotnikow@gmx.de";
in {
  config = {
    programs.git.settings.user = {
      inherit name email;
    };

    programs.bash.initExtra = ''
      export GH_TOKEN=$(secret-tool lookup Title "gh_token")
    '';

    sops.secrets.rclone_gdrive_token = {
      sopsFile = ./secrets.yml;
    };

    services.syncthing.settings = {
      options.urAccepted = -1;
      devices = {
        "tower-of-power".id = "PKVZ6VE-ENI7R5E-U4FFFH4-EEP6324-2Z3IVID-CKRQ7F3-YBX3EAI-NY5FTQD";
        "xiaomi-15".id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
        "hp-430-g7".id = "NJ467AX-LE6UDUN-5PQUZW7-ORDECKC-MWWUZIY-LLYXZ3Q-A2SNZPR-3FE2NQP";
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

    programs.thunderbird.profiles."${name}" = {
      isDefault = true;
      settings = {
        "mailnews.start_page.enabled" = true;
        "mailnews.start_page.url" = "https://thunderbird.net/${pkgs.thunderbird.version}/releasenotes/";
      };
    };

    accounts = let
      thunderbird = {
        enable = true;
        profiles = ["${name}"];
      };
      gmail = "megustastudiofails@gmail.com";
    in {
      calendar.accounts."${gmail}" = {
        primary = true;
        inherit thunderbird;
        remote = {
          type = "caldav";
          url = "https://apidata.googleusercontent.com/caldav/v2/${gmail}/events/";
          userName = gmail;
        };
      };

      contact.accounts."${gmail}" = {
        inherit thunderbird;
        remote = {
          type = "carddav";
          url = "https://www.googleapis.com/carddav/v1/principals/${gmail}/lists/default/";
          userName = gmail;
        };
      };

      email.accounts."${email}" = {
        primary = true;
        inherit thunderbird;
        realName = "Borislaw Sotnikow";
        address = email;
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
      };
    };
  };
}
