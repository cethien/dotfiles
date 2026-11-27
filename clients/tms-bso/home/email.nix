{
  lib,
  config,
  pkgs,
  ...
}: let
  mail = "b.sotnikow@tmsproshop.de";
  userName = "b.sotnikow@ad.tmsproshop.de";
in {
  config = {
    accounts.email.accounts."${mail}" = {
      primary = true;

      thunderbird = {
        enable = true;
        profiles = ["${mail}"];
      };

      aerc = {
        enable = true;
        extraAccounts = {
          "enable-folders-sort" = true;
          "folders-sort" = "INBOX,Drafts,Junk,Sent,Archive";
        };
      };

      passwordCommand = "cat ${config.sops.secrets."tms/mail_password".path}";

      address = mail;
      realName = "Borislaw Sotnikow";

      inherit userName;
      smtp = {
        host = "localhost";
        port = 1025;
        tls.enable = false;
      };
      imap = {
        host = "localhost";
        port = 55555;
        tls.enable = false;
      };
    };

    programs.thunderbird.profiles."${mail}" = {
      isDefault = true;
      settings = {
        "calendar.itip.send_notifications" = false;
        "calendar.itip.notify" = false;
        "calendar.scheduling.show_invite_message" = false;

        "ldap_2.servers.tmsproshop.description" = "TMS Pro Shop GmbH";
        "ldap_2.servers.tmsproshop.uri" = "ldap://localhost:1389/ou=people??sub?(objectclass=*)";
        "ldap_2.servers.tmsproshop.auth.dn" = userName;
        "ldap_2.servers.tmsproshop.baseIDN" = "ou=people";
        "ldap_2.servers.tmsproshop.maxHits" = 100;

        "ldap_2.autoComplete.useDirectory" = true;
        "ldap_2.autoComplete.directoryServer" = "ldap_2.servers.tmsproshop";
      };

      feedAccounts = {
        "News" = {};
      };
    };

    sops.secrets."tms/mail_password" = {};

    services.davmail = {
      imitateOutlook = true;
      settings = {
        "davmail.url" = "https://outlook.tmsproshop.de/EWS/Exchange.asmx";
        "davmail.allowRemote" = false;
        "davmail.bindAddress" = "127.0.0.1";

        "davmail.imapPort" = 55555;
        "davmail.imapIdleDelay" = 1;
        "davmail.smtpPort" = 1025;
        "davmail.caldavPort" = 1080;
        "davmail.ldapPort" = 1389;

        "davmail.caldavAutoSchedule" = true;
        "davmail.folderSizeLimit" = 500;
        "davmail.smtpSaveInSent" = true;

        "log4j.logger.rootLogger" = "INFO";
      };
    };
  };
}
