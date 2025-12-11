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
    (n: {
      name = n;
      value = rec {
        thunderbird.enable = true;
        address = n;
        userName = n;
        realName = n;
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

  primary = let
    name = "b.sotnikow@tmsproshop.de";
  in {
    ${name} = {
      primary = true;
      userName = name;
      address = name;
    };
  };
in
  primary // accs
