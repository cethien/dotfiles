{config, lib, pkgs-unstable, ...}: let
  homepage = pkgs-unstable.homepage-dashboard.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        mkdir -p $out/share/homepage/public/images
        cp ${./images/background.jpg} $out/share/homepage/public/images/background.jpg
        cp ${./images/logo.png} $out/share/homepage/public/images/logo.png
      '';
  });
in {
  options.homelab.homepage.services = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [];
    description = "Service cards contributed by each homelab service module.";
  };

  config = {
    services.homepage-dashboard = {
      enable = true;
      package = homepage;
      listenPort = 8082;
      allowedHosts = "holzrussen.net";
      openFirewall = false;

      settings = {
        title = "holzrussen.net";
        hideVersion = true;
        disableUpdateCheck = true;
        useEqualHeights = true;
        fullWidth = true;
        headerStyle = "boxed";
        cardStyle = "hairline";
        blockStyle = "refined";
        background = {
          image = "/images/background.jpg";
          blur = "sm";
          saturate = 50;
          brightness = 50;
          opacity = 50;
        };
        layout = [
          {services = {};}
          {
            infra = {
              style = "row";
              columns = 2;
            };
          }
          {Links = {};}
        ];
      };

      services = [
        {
          services = config.homelab.homepage.services;
        }
        {
          infra = [
            {
              "GL.iNet Router" = {
                href = "http://172.16.1.1";
                icon = "sh-openwrt";
                description = "GL.iNet gateway";
              };
            }
            {
              "AdGuard Home" = {
                href = "http://172.16.1.1:3000";
                icon = "sh-adguard-home";
                description = "DNS ad blocking";
              };
            }
          ];
        }
      ];

      widgets = [
        {
          logo = {
            icon = "/images/logo.png";
          };
        }
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
            uptime = true;
            network = true;
            refresh = 3000;
          };
        }
        {
          datetime = {
            text_size = "xl";
            format = {
              timeStyle = "short";
              hourCycle = "h23";
            };
          };
        }
      ];

      bookmarks = [
        {
          Links = [
            {
              dotfiles = [
                {
                  icon = "sh-github";
                  href = "https://github.com/cethien/dotfiles";
                  description = "this repo";
                }
              ];
            }
            {
              Cloudflare = [
                {
                  icon = "sh-cloudflare";
                  href = "https://dash.cloudflare.com";
                  description = "domain DNS";
                }
              ];
            }
          ];
        }
      ];
    };

    services.caddy.virtualHosts."holzrussen.net".extraConfig = ''
      import cloudflare_tls
      reverse_proxy 127.0.0.1:8082
    '';
  };
}
