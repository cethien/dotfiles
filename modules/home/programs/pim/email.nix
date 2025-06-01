{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.pim.email;
  primary = "borislaw.sotnikow@gmx.de";
in {
  options.deeznuts.programs.pim.email = {
    enable = mkEnableOption "email";
    email = {
      primary = mkOption {
        type = types.str;
        default = "${primary}";
        description = "primary email address. is also the default email address";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.mbsync.enable = true;
    programs.neomutt.enable = true;
    accounts.email = {
      maildirBasePath = ".mail";

      accounts.${cfg.email.primary} = {
        mbsync.enable = true;
        mbsync = {
          create = "both";
          remove = "both";
          expunge = "both";
        };
        neomutt.enable = true;

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
}
