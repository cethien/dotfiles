{pkgs}: {
  bookmarks = [
    {
      name = "shops";
      bookmarks = [
        {
          name = "ld";
          url = "https://leitplanken-discounter.de";
        }
        {
          name = "ld wp";
          url = "https://leitplanken-discounter.de/wp-login";
        }
        {
          name = "vd";
          url = "https://verkehrsschilder-discounter.de";
        }
        {
          name = "vd wp";
          url = "https://verkehrsschilder-discounter.de/wp-login";
        }
        {
          name = "ehs";
          url = "https://erstehilfeshop.de";
        }
        {
          name = "ass";
          url = "https://absperrshop.de";
        }
        {
          name = "rss";
          url = "https://rammschutzshop.de";
        }
        {
          name = "mks";
          url = "https://markierungsshop.de";
        }
      ];
    }
    {
      name = "inv";
      url = "https://inventory.tmspro.shop";
      tags = ["snipe-it" "inventory"];
    }

    {
      name = "intranet";
      url = "https://tmspro.shop";
      tags = ["homarr" "landingpage"];
    }
    {
      name = "vw";
      url = "https://vault.tmspro.shop";
      tags = ["vaultwarden" "passwords"];
    }
    {
      name = "vw admin";
      url = "https://vault.tmspro.shop/admin";
      tags = ["vaultwarden" "admin" "passwords"];
    }

    {
      name = "weclapp test";
      url = "https://update.weclapp.tmspro.shop/";
      tags = ["erp"];
    }
    {
      name = "weclapp";
      url = "https://weclapp.tmspro.shop/";
      tags = ["erp"];
    }

    {
      name = "kanboard";
      url = "https://kanboard.tmspro.shop/";
      tags = ["tasks"];
    }
    {
      name = "bnl";
      url = "https://bnl.tmspro.shop/";
      tags = ["bildnamensliste" "tools"];
    }

    {
      name = "toja";
      url = "https://toja.tmspro.shop/";
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
      tags = ["atlassian" "tasks"];
    }
    {
      name = "confluence";
      url = "https://tmsproshop.atlassian.net/wiki";
      tags = ["atlassian" "docs"];
    }
    {
      name = "bb";
      url = "bitbucket.org/tmsproshop";
      tags = ["bitbucket" "source" "git"];
    }
    {
      name = "magento bb";
      url = "bitbucket.org/tmsproshop";
      tags = ["shops" "bitbucket" "source" "git" "project"];
    }
    {
      name = "grafana";
      url = "https://grafana.tmspro.shop";
      tags = ["monitoring"];
    }
    {
      name = "prom";
      url = "https://metrics.tmspro.shop";
      tags = ["prometheus" "monitoring"];
    }
    {
      name = "alerts";
      url = "https://alerts.tmspro.shop";
      tags = ["alertmanager" "monitoring"];
    }
    {
      name = "mailpit";
      url = "https://mailpit.tmspro.shop";
      tags = ["mail relay"];
    }
    {
      name = "gh";
      url = "https://github.com/orgs/tmsproshopgmbh/repositories";
      tags = ["github" "source" "git" "projects"];
    }
    {
      name = "infra gh";
      url = "https://github.com/orgs/tmsproshopgmbh/infra";
      tags = ["github" "source" "git" "repo"];
    }
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
      url = "https://10.0.10.5:8006";
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
      name = "domains";
      url = "https://domain-bestellsystem.de";
      tags = ["kasserver" "mail" "domains" "cdn" "ftp"];
    }
    {
      name = "maxcluster";
      url = "https://app.maxcluster.de/";
      tags = ["hosting" "magento" "staging"];
    }
    {
      name = "hetzner";
      url = "https://robot.hetzner.com";
      tags = ["hosting" "magento" "staging"];
    }
    {
      name = "cf";
      url = "https://dash.cloudflare.com/";
      tags = ["cloudflare" "dns" "domains"];
    }
  ];

  extensions = with pkgs.firefox-addons; [
    bitwarden
  ];
}
