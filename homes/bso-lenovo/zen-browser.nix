{config, ...}: {
  config = {
    programs.zen-browser.enable = true;
    programs.browser.default = config.programs.zen-browser.package;
    programs.zen-browser.profiles."${config.home.username}" = let
      containers = {
        logged-out = {
          id = 1;
          color = "blue";
          icon = "chill";
        };
        admin = {
          id = 2;
          color = "purple";
          icon = "circle";
        };
        "tailscale" = {
          id = 3;
          color = "yellow";
          icon = "vacation";
        };
        "tailscale/admin" = {
          id = 4;
          color = "orange";
          icon = "vacation";
        };
      };

      spaces."lets get this bread" = {
        id = "cd0b7a9b-bb11-42e8-a10a-52ea6813e6b4";
        position = 1000;
        icon = "🍞";
      };

      pins = {
        "admin" = {
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://infra.tmspro.shop/";
          isEssential = true;
          position = 101;
        };
        "tmspro.shop" = {
          id = "96070d37-4b78-490f-87d1-884474bd9434";
          url = "https://start.tmspro.shop:7575";
          isEssential = true;
          position = 102;
        };

        "Outlook" = {
          id = "eee232e4-72d9-4d7c-b4e6-02a1f6155f7f";
          url = "https://outlook.tmsproshop.de/owa";
          isEssential = true;
          position = 110;
        };
        "Jira" = {
          id = "8af62707-0722-4049-9801-bedced343333";
          url = "https://tmsproshop.atlassian.net/jira/for-you";
          position = 111;
        };
        "Netgate pfSense Plus" = {
          id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
          url = "https://github.com/";
          position = 112;
        };
        "proxmox" = {
          id = "";
          url = "https://10.180.80.252:8006";
          position = 113;
        };
      };
    in {
      containersForce = true;
      inherit containers;
      pinsForce = true;
      inherit pins;
      spacesForce = true;
      inherit spaces;
    };
  };
}
