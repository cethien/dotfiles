let
  email = "borislaw.sotnikow@gmx.de";
in {
  config.accounts.email.accounts.${email} = rec {
    thunderbird.enable = true;

    primary = true;
    address = email;
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
    userName = email;
    passwordCommand = "secret-tool lookup smtp-host ${smtp.host} smtp-user ${address}";
  };
}
