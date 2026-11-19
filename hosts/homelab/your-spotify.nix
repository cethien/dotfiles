{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "spotify.holzrussen.net";
  port = 3000;
  apiBase = "https://${domain}/api";

  cfg = config.services.your_spotify;
in {
  config = {
    sops.secrets."your_spotify/client_id" = {};
    sops.secrets."your_spotify/client_secret" = {
      restartUnits = ["your_spotify.service"];
    };

    sops.templates."your_spotify_env" = {
      content = ''
        SPOTIFY_PUBLIC=${config.sops.placeholder."your_spotify/client_id"}
      '';
      restartUnits = ["your_spotify.service"];
    };

    services.your_spotify = {
      enable = true;
      enableLocalDB = true;
      package = pkgs.your_spotify_fork;

      spotifySecretFile = config.sops.secrets."your_spotify/client_secret".path;

      settings = {
        CLIENT_ENDPOINT = "https://${domain}";
        API_ENDPOINT = "https://${domain}";
        PORT = port;
        TIMEZONE = "Europe/Berlin";
        SPOTIFY_PUBLIC = "dummy-client-id";
      };

      clientPackage = pkgs.your_spotify_fork.client.override {
        apiEndpoint = apiBase;
      };
    };

    systemd.services.your_spotify.serviceConfig.EnvironmentFile = lib.mkAfter [
      config.sops.templates."your_spotify_env".path
    ];

    services.mongodb.enable = true;

    services.caddy.virtualHosts.${domain}.extraConfig = ''
      import cloudflare_tls
      encode zstd gzip

      handle /oauth/spotify/callback {
        reverse_proxy 127.0.0.1:${toString port}
      }

      handle_path /api/* {
        reverse_proxy 127.0.0.1:${toString port}
      }

      handle {
        root * ${cfg.clientPackage}
        try_files {path} /index.html
        file_server
      }
    '';

    homelab.homepage.services = [
      {
        "Your Spotify" = {
          href = "https://${domain}";
          icon = "sh-spotify";
          description = "listening statistics";
        };
      }
    ];
  };
}
