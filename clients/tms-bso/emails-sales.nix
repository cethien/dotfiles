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

  host = "w01d0a32.kasserver.com";

  accs = builtins.listToAttrs (map
    (name: {
      inherit name;
      value = {
        thunderbird = {
          enable = true;
          profiles = ["sales"];
        };

        realName = name;
        address = name;

        userName = name;
        imap = {
          inherit host;
          port = 993;
          tls.enable = true;
        };
        smtp = {
          inherit host;
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
