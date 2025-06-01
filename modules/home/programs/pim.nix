{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.pim;
in {
  options.deeznuts.programs.pim = {
    enable = mkEnableOption "pim";
  };

  config = mkIf cfg.enable {
    programs.mbsync.enable = true;
    programs.neomutt.enable = true;

    accounts.email = {
      maildirBasePath = ".mail";
      accounts."borislaw.sotnikow@gmx.de" = {
        primary = true;

        mbsync.enable = true;
        mbsync = {
          create = "both";
          remove = "both";
          expunge = "both";
        };
        neomutt.enable = true;

        address = "borislaw.sotnikow@gmx.de";
        realName = "Borislaw Sotnikow";
        userName = "borislaw.sotnikow@gmx.de";

        passwordCommand = "secret-tool lookup Title mail.gmx.net UserName borislaw.sotnikow@gmx.de";

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
