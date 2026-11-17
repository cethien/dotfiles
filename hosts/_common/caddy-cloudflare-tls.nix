{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.services.caddy.cloudflare-tls;
in {
  options.services.caddy = {
    cloudflare-tls = {
      enable = lib.mkEnableOption "Cloudflare DNS plugin for Caddy TLS";
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."cloudflare_api_token" = {
      owner = "caddy";
      group = "caddy";
    };

    sops.templates."caddy_env".content = ''
      CLOUDFLARE_API_TOKEN=${config.sops.placeholder."cloudflare_api_token"}
    '';

    services.caddy = {
      enable = true;
      package = pkgs-unstable.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.4"];
        hash = "sha256-QSiwKqKvSxhksWBF4/MlBOpyXba5xOQ2sRwA0R7399E=";
      };
      environmentFile = config.sops.templates."caddy_env".path;
      email = "borislaw.sotnikow@gmx.de";
      extraConfig = ''
        (cloudflare_tls) {
            tls {
                dns cloudflare {env.CLOUDFLARE_API_TOKEN}
                resolvers 1.1.1.1 1.0.0.1
            }
        }
      '';
    };
  };
}
