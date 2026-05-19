let
  accNames = [
    "verkauf@tmsproshop.de"
    "verkauf@rammschutzshop.de"
    "verkauf@markierungsshop.de"
    "verkauf@erstehilfeshop.de"
    "verkauf@absperrshop.de"
    "verkauf@leitplanken-discounter.de"
    "verkauf@verkehrsschilder-discounter.de"
    "bestellungen-magento@tmsproshop.de"
  ];

  accs = builtins.listToAttrs (map
    (name: {
      inherit name;
      value = rec {
        thunderbird = {
          enable = true;
          profiles = ["sales"];
        };

        realName = name;
        address = name;

        userName = name;
        imap = {
          host = "w01d0a32.kasserver.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = imap.host;
          port = 465;
          tls.enable = true;
        };
      };
    })
    accNames);
in {
  accounts.email.accounts = accs;
  programs.thunderbird.profiles."sales".settings = {};

  xdg.desktopEntries.thunderbird-sales = {
    name = "Thunderbird (verkauf@tmsproshop.de)";
    icon = "thunderbird";
    exec = ''thunderbird -P "sales"'';
  };
}
