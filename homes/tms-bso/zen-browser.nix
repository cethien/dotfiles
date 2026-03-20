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
        "private" = {
          id = 5;
          color = "green";
          icon = "fence";
        };
      };

      spaces."lets get this bread" = {
        id = "8e725798-defd-4b13-bc8b-ae3fd4bad512";
        position = 1000;
        icon = "🍞";
      };

      pins = {
        "outlook" = {
          id = "eee232e4-72d9-4d7c-b4e6-02a1f6155f7f";
          url = "https://outlook.tmsproshop.de/owa";
          isEssential = true;
          position = 100;
        };

        "admin" = {
          id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
          url = "https://infra.tmspro.shop/";
          position = 110;
        };
        "tmspro.shop" = {
          id = "96070d37-4b78-490f-87d1-884474bd9434";
          url = "https://tmspro.shop";
          position = 111;
        };
      };

      bookmarks = [
        {
          name = "startpage";
          url = "https://tmspro.shop";
          tags = ["landingpage"];
        }
        {
          name = "vaultwarden";
          url = "https://vault.tmspro.shop";
          tags = ["passwords"];
        }
        {
          name = "vaultwarden admin";
          url = "https://vault.tmspro.shop/admin";
          tags = ["passwords"];
        }
        {
          name = "weclapp test";
          url = "https://weclapp-test.tmspro.shop/";
          tags = ["erp"];
        }
        {
          name = "kanboard";
          url = "https://kanboard.tmspro.shop/";
          tags = ["tasks"];
        }
        {
          name = "weclapp test (update)";
          url = "https://update.weclapp.tmspro.shop/";
          tags = ["erp"];
        }
        {
          name = "weclapp";
          url = "https://weclapp.tmspro.shop/";
          tags = ["erp"];
        }
        {
          name = "bildnamesliste";
          url = "https://bnl.tmspro.shop/";
          tags = ["tools"];
        }
        {
          name = "sherlock";
          url = "https://sherlock.tmspro.shop/";
          tags = ["tools"];
        }
        {
          name = "toja v2";
          url = "https://toja.tmspro.shop/";
          tags = ["tools" "beta"];
        }
        {
          name = "toja";
          url = "https://toja-prod.tmspro.shop/";
          tags = ["tools"];
        }
        {
          name = "anna-auftrag";
          url = "https://anna-auftrag.tmspro.shop/";
          tags = ["tools"];
        }

        {
          name = "timas";
          url = "https://timas.tmspro.shop/";
          tags = ["payroll"];
        }

        {
          name = "jira";
          url = "https://tmsproshop.atlassian.net/jira";
          tags = ["tasks"];
        }
        {
          name = "confluence";
          url = "https://tmsproshop.atlassian.net/wiki";
          tags = ["docs"];
        }
        {
          name = "bitbucket";
          url = "bitbucket.org/tmsproshop";
          tags = ["source" "git"];
        }
        {
          name = "magento repo";
          url = "bitbucket.org/tmsproshop";
          tags = ["source" "git" "project"];
        }
        {
          name = "grafana";
          url = "https://grafana.tmspro.shop";
          tags = ["monitoring"];
        }
        {
          name = "prometheus";
          url = "https://prometheus.tmspro.shop";
          tags = ["monitoring"];
        }
        {
          name = "alertmanager";
          url = "https://alerts.tmspro.shop";
          tags = ["monitoring"];
        }
        {
          name = "mailpit";
          url = "https://mailpit.tmspro.shop";
          tags = ["mail relay"];
        }
        {
          name = "github org";
          url = "https://github.com/orgs/tmsproshopgmbh/repositories";
          tags = ["source" "git" "projects"];
        }
        {
          name = "github infra";
          url = "https://github.com/orgs/tmsproshopgmbh/infra";
          tags = ["source" "git" "repo"];
        }
        {
          name = "infra";
          bookmarks = [
            {
              name = "o2business";
              url = "https://admin.digitalphone.o2business.de/";
              tags = ["telefonie" "phone"];
            }
            {
              name = "tailscale admin";
              url = "https://login.tailscale.com/admin";
              tags = ["tailscale" "vpn"];
            }
            {
              name = "pve-node-a";
              url = "https://10.180.80.252:8006";
              tags = ["proxmox" "vms"];
            }
            {
              name = "pve-node-b";
              url = "https://10.180.80.250:8006";
              tags = ["proxmox" "vms"];
            }
            {
              name = "pve-node-c";
              url = "https://10.0.10.7:8006";
              tags = ["proxmox" "vms"];
            }
            {
              name = "pfsense";
              url = "https://10.180.80.254";
              tags = ["firewall" "routing" "network"];
            }
            {
              name = "unifi";
              url = "https://10.180.80.99";
              tags = ["switch" "network"];
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
            {
              name = "allinkl";
              url = "https://kasserver.com/";
              tags = ["kasserver" "mail" "domains" "cdn" "ftp"];
            }
            {
              name = "maxcluster";
              url = "https://app.maxcluster.de/";
              tags = ["hosting" "magento" "staging"];
            }
            {
              name = "hetzner-console";
              url = "https://console.hetzner.com";
              tags = ["hosting" "magento" "staging"];
            }
          ];
        }
      ];
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        passbolt
        bitwarden
      ];
    in {
      bookmarks = {
        force = true;
        settings = bookmarks;
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
