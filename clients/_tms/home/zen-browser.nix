{pkgs}: {
  bookmarks = [
    {
      name = "shops";
      bookmarks = [
        {
          name = "leitplanken-discounter";
          url = "https://leitplanken-discounter.de";
          tags = ["ld"];
        }
        {
          name = "leitplanken-discounter admin";
          url = "https://leitplanken-discounter.de/wp-login";
          tags = ["ld" "wordpress"];
        }
        {
          name = "verkehrsschilder-discounter";
          url = "https://verkehrsschilder-discounter.de";
          tags = ["vd"];
        }
        {
          name = "verkehrsschilder-discounter admin";
          url = "https://verkehrsschilder-discounter.de/wp-login";
          tags = ["vd" "wordpress"];
        }
        {
          name = "erstehilfeshop";
          url = "https://erstehilfeshop.de";
          tags = ["ehs"];
        }
        {
          name = "absperrshop";
          url = "https://absperrshop.de";
          tags = ["ass"];
        }
        {
          name = "rammschutzshop";
          url = "https://rammschutzshop.de";
          tags = ["rss"];
        }
        {
          name = "markierungsshop";
          url = "https://markierungsshop.de";
          tags = ["mks"];
        }
      ];
    }
    {
      name = "snipe-it";
      url = "https://snipe-it.tmspro.shop";
      tags = ["snipe-it" "inventory"];
    }

    {
      name = "intranet";
      url = "https://tmspro.shop";
      tags = ["homarr" "landingpage"];
    }
    {
      name = "vaultwarden";
      url = "https://vault.tmspro.shop";
      tags = ["vaultwarden" "passwords"];
    }
    {
      name = "vaultwarden admin";
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
      name = "bildnamensliste";
      url = "https://bnl.tmspro.shop/";
      tags = ["bnl" "tools"];
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
      name = "bitbucket";
      url = "bitbucket.org/tmsproshop";
      tags = ["bb" "source" "git"];
    }
    {
      name = "magento bitbucket";
      url = "bitbucket.org/tmsproshop";
      tags = ["shops" "bb" "source" "git" "project"];
    }
    {
      name = "grafana";
      url = "https://grafana.tmspro.shop";
      tags = ["monitoring"];
    }
    {
      name = "prometheus";
      url = "https://prometheus.tmspro.shop";
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
      name = "github";
      url = "https://github.com/orgs/tmsproshopgmbh/repositories";
      tags = ["github" "source" "git" "projects"];
    }
    {
      name = "infra github";
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
      name = "truenas";
      url = "https://10.180.80.87";
      tags = ["truenas" "backups"];
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
      name = "cloudflare";
      url = "https://dash.cloudflare.com/";
      tags = ["dns" "domains"];
    }
  ];

  extensions = with pkgs.firefox-addons; [
    bitwarden
  ];
}
