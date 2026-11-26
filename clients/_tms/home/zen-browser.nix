{pkgs}: {
  bookmarks = [
    {
      name = "auth";
      url = "https://auth.tmspro.shop";
      tags = ["authentik" "admin" "sso"];
    }
    {
      name = "dbasus";
      url = "https://databasus.tmspro.shop";
      tags = ["databasus" "admin" "backups" "database"];
    }
    {
      name = "zb";
      url = "https://zerobyte.tmspro.shop";
      tags = ["zerobyte" "restic" "admin" "backups" "data"];
    }
    {
      name = "dozzle";
      url = "https://dozzle.tmspro.shop";
      tags = ["docker" "admin"];
    }
    {
      name = "wud";
      url = "https://wud.tmspro.shop";
      tags = ["whats up docker" "docker" "admin"];
    }
    {
      name = "inv";
      url = "https://inventory.tmspro.shop";
      tags = ["snipe-it" "inventory"];
    }
    {
      name = "intra";
      url = "https://tmspro.shop";
      tags = ["homarr" "intranet" "landingpage"];
    }
    {
      name = "bw";
      url = "https://vault.tmspro.shop";
      tags = ["bitwarden" "vaultwarden" "passwords"];
    }
    {
      name = "bw-admin";
      url = "https://vault.tmspro.shop/admin";
      tags = ["bitwarden" "vaultwarden" "admin" "passwords"];
    }

    {
      name = "weclapp-test";
      url = "https://update.weclapp.tmspro.shop/";
      tags = ["erp"];
    }
    {
      name = "weclapp";
      url = "https://weclapp.tmspro.shop/";
      tags = ["erp"];
    }

    {
      name = "kb";
      url = "https://kanboard.tmspro.shop/";
      tags = ["kanboard" "tasks"];
    }
    {
      name = "bnl";
      url = "https://bnl.tmspro.shop/";
      tags = ["bildnamenliste" "tools"];
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
      tags = ["jira" "atlassian" "tasks"];
    }
    {
      name = "wiki";
      url = "https://tmsproshop.atlassian.net/wiki";
      tags = ["confluence" "atlassian" "docs"];
    }
    {
      name = "bb";
      url = "https://bitbucket.org/tmsproshop";
      tags = ["bitbucket" "source" "git"];
    }
    {
      name = "bb-magento";
      url = "https://bitbucket.org/tmsproshop/magento";
      tags = ["shops" "bitbucket" "source" "git" "project"];
    }
    {
      name = "wac";
      url = "https://wac.tmspro.shop";
      tags = ["windows admin center" "windows server"];
    }
    {
      name = "grafana-explore";
      url = "https://grafana.tmspro.shop/explore";
      tags = ["monitoring" "grafana"];
    }
    {
      name = "grafana";
      url = "https://grafana.tmspro.shop";
      tags = ["monitoring"];
    }
    {
      name = "prom";
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
      name = "gh-tms";
      url = "https://github.com/orgs/tmsproshopgmbh/repositories";
      tags = ["github" "source" "git" "projects"];
    }
    {
      name = "gh-infra";
      url = "https://github.com/orgs/tmsproshopgmbh/infra";
      tags = ["github" "source" "git" "repo"];
    }
    {
      name = "o2";
      url = "https://newadmin.digitalphone.o2business.de/";
      tags = ["telefonie" "phone"];
    }
    {
      name = "tailscale admin";
      url = "https://login.tailscale.com/admin";
      tags = ["tailscale" "vpn"];
    }
    {
      name = "slack";
      url = "https://app.slack.com/client";
      tags = ["messenger"];
    }
    {
      name = "pve-a";
      url = "https://10.0.10.5:8006";
      tags = ["pve-node-a" "proxmox" "vms"];
    }
    {
      name = "pve-node-b";
      url = "https://10.180.80.250:8006";
      tags = ["pve-node-b" "proxmox" "vms"];
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
      tags = ["ubiquity" "switch" "network"];
    }
    {
      name = "pve storage";
      url = "https://10.180.80.3:5001/";
      tags = ["synology" "nas" "nfs"];
    }
    {
      name = "smb";
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

    {
      name = "shops";
      bookmarks = [
        {
          name = "ld";
          url = "https://leitplanken-discounter.de";
          tags = ["leitplanken-discounter"];
        }
        {
          name = "ld-admin";
          url = "https://leitplanken-discounter.de/wp-login";
          tags = ["leitplanken-discounter" "wordpress"];
        }
        {
          name = "vd";
          url = "https://verkehrsschilder-discounter.de";
          tags = ["verkehrsschilder-discounter"];
        }
        {
          name = "vd-admin";
          url = "https://verkehrsschilder-discounter.de/wp-login";
          tags = ["verkehrsschilder-discounter" "wordpress"];
        }
        {
          name = "mage-admin";
          url = "https://absperrshop.de/admin_b1sk2x";
          tags = ["magento" "shops" "admin"];
        }
        {
          name = "ehs";
          url = "https://erstehilfeshop.de";
          tags = ["erstehilfeshop" "shops"];
        }
        {
          name = "ass";
          url = "https://absperrshop.de";
          tags = ["absperrshop" "shops"];
        }
        {
          name = "rss";
          url = "https://rammschutzshop.de";
          tags = ["rammschutzshop" "shops"];
        }
        {
          name = "mks";
          url = "https://markierungsshop.de";
          tags = ["markierungsshop" "shops"];
        }
      ];
    }
  ];

  extensions = with pkgs.firefox-addons; [
    bitwarden
  ];
}
