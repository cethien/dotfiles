{
  lib,
  config,
  pkgs,
  ...
}: let
  mail = "b.sotnikow@tmsproshop.de";
  userName = "b.sotnikow@ad.tmsproshop.de";
in {
  # imports = [./emails-sales.nix];

  config = {
    accounts.email.accounts."${mail}" = {
      primary = true;
      thunderbird = {
        enable = true;
        profiles = ["${mail}"];
      };

      address = mail;
      realName = "Borislaw Sotnikow";

      signature = {
        htmlFormat = true;
        delimiter = "---";
        showSignature = "append";
        text = builtins.readFile ./email-signature.html;
      };

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

    accounts.calendar.accounts."${mail}" = {
      primary = true;
      remote = {
        url = "http://localhost:1080/users/${mail}/calendar/";
        type = "caldav";
        inherit userName;
      };

      thunderbird = {
        enable = true;
        profiles = ["${mail}"];
        color = "#b798f1";
      };
    };

    programs.thunderbird.profiles."${mail}" = {
      isDefault = true;
      settings = {
        "calendar.itip.send_notifications" = false;
        "calendar.itip.notify" = false;
        "calendar.scheduling.show_invite_message" = false;

        "ldap_2.servers.davmail.description" = "DavMail Adressbuch";
        "ldap_2.servers.davmail.uri" = "ldap://localhost:1389/ou=people";
        "ldap_2.servers.davmail.baseIDN" = "ou=people";
        "ldap_2.servers.davmail.auth.dn" = userName;
        "ldap_2.servers.davmail.maxHits" = 100;

        "ldap_2.autoComplete.useDirectory" = true;
        "ldap_2.autoComplete.directoryServer" = "ldap_2.servers.davmail";
      };
    };

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
