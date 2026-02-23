{
  pkgs,
  config,
  ...
}: {
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
        "tailscale/member" = {
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
        id = "8e725798-defd-4b13-bc8b-ae3fd4bad512";
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
          url = "http://start.tmspro.shop:7575";
          isEssential = true;
          position = 102;
        };
        "Outlook" = {
          id = "eee232e4-72d9-4d7c-b4e6-02a1f6155f7f";
          url = "https://outlook.tmsproshop.de/owa";
          isEssential = true;
          position = 110;
        };
      };

      bookmarks = [
        {
          name = "passbolt";
          url = "https://pass.tmspro.shop";
          tags = ["passwords"];
        }
        {
          name = "vaultwarden";
          url = "https://vault.tmspro.shop";
          tags = ["passwords"];
        }
        {
          name = "bookstack";
          url = "https://docs.tmspro.shop";
          tags = ["docs"];
        }

        {
          name = "jira";
          url = "https://tmsproshop.atlassian.net/jira";
          tags = ["atlassian" "todo"];
        }
        {
          name = "confluence";
          url = "https://tmsproshop.atlassian.net/wiki";
          tags = ["atlassian" "docs"];
        }
        {
          name = "allinkl";
          url = "https://kasserver.com/";
          tags = ["kasserver" "email" "domains" "cdn"];
        }
        {
          name = "tailscale admin";
          url = "https://login.tailscale.com/admin";
          tags = ["tailscale" "vpn"];
        }

        {
          name = "pve-node-a";
          url = "https://10.180.80.252:8006";
          tags = ["proxmox"];
        }
        {
          name = "pve-node-b";
          url = "https://10.180.80.250:8006";
          tags = ["proxmox"];
        }
        {
          name = "pve-node-c";
          url = "https://10.0.10.7:8006";
          tags = ["proxmox"];
        }
        {
          name = "pfsense";
          url = "https://10.180.80.254";
          tags = ["netgate" "firewall"];
        }
        {
          name = "unifi";
          url = "https://10.180.80.99";
          tags = ["switch" "network" "ubiquity"];
        }
        {
          name = "pve storage";
          url = "https://10.180.80.3:5001/";
          tags = ["synology" "nas" "nfs"];
        }
        {
          name = "smb storage";
          url = "https://10.102.99.213:5001/";
          tags = ["synology" "san" "smb"];
        }
      ];
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        passbolt
        bitwarden
      ];
    in {
      bookmarks = {
        force = true;
        settings = [{inherit bookmarks;}];
      };
      extensions.packages = extensions;
      containersForce = true;
      inherit containers;
      pinsForce = true;
      inherit pins;
      spacesForce = true;
      inherit spaces;
    };
  };
}
