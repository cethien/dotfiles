{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.pim;
  primary = "borislaw.sotnikow@gmx.de";
in {
  options.deeznuts.pim = {
    enable = mkEnableOption "pim";

    email.primary = mkOption {
      type = types.str;
      default = "${primary}";
      description = "primary email address. is also the default email address";
    };

    thunderbird.enable = mkEnableOption "thunderbird";
    office.enable = mkEnableOption "office suite";
  };

  config = {
    programs.onlyoffice.enable = cfg.office.enable;
    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "application/msword"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
        "application/vnd.ms-word.document.macroEnabled.12"
        "application/vnd.ms-word.template.macroEnabled.12"

        "application/vnd.ms-excel"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "application/vnd.ms-excel.template.macroEnabled.12"
        "application/vnd.ms-excel.addin.macroEnabled.12"
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12"

        "application/vnd.ms-powerpoint"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.openxmlformats-officedocument.presentationml.template"
        "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
        "application/vnd.ms-powerpoint.addin.macroEnabled.12"
        "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
        "application/vnd.ms-powerpoint.template.macroEnabled.12"
        "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"

        "application/vnd.ms-access"
      ];
    in
      builtins.listToAttrs (map (mimeType: {
          name = mimeType;
          value = mkIf cfg.office.enable ["onlyoffice-desktopeditors.desktop"];
        })
        mimeTypes);

    programs.mbsync.enable = cfg.enable;
    programs.neomutt.enable = cfg.enable;
    programs.thunderbird = {
      enable = cfg.thunderbird.enable;
      profiles = {
        "${email.primary}" = {
          isDefault = true;
        };
      };
    };

    accounts = mkIf cfg.enable {
      calendar = {
        basePath = ".cal";
      };

      email = {
        maildirBasePath = ".mail";

        accounts.${cfg.email.primary} = {
          mbsync.enable = true;
          mbsync = {
            create = "both";
            remove = "both";
            expunge = "both";
          };
          neomutt.enable = true;
          thunderbird.enable = cfg.thunderbird.enable;

          primary = true;
          address = "${cfg.email.primary}";
          realName = "Borislaw Sotnikow";

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
          userName = "${cfg.email.primary}";
          passwordCommand = "secret-tool lookup Title mail.gmx.net UserName ${cfg.email.primary}";
        };
      };
    };
  };
}
