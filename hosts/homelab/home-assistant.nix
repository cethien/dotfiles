{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  # HA 2026.8+ manages HTTP settings in .storage/http, not in configuration.yaml.
  # YAML is migrated once and then ignored; seeding the stable slot directly
  # avoids a pending config that has to be confirmed in the UI within 5 minutes.
  haConfig = pkgs.writeText "home-assistant-configuration.yaml" ''
    homeassistant:
      time_zone: Europe/Berlin
    lovelace:
      dashboards: {}
      resources: []
  '';

  httpStore = pkgs.writeText "home-assistant-http-store.json" (builtins.toJSON {
    version = 2;
    minor_version = 2;
    key = "http";
    data = {
      stable = {
        server_host = ["127.0.0.1"];
        server_port = 8123;
        cors_allowed_origins = ["https://cast.home-assistant.io"];
        use_x_forwarded_for = true;
        trusted_proxies = ["127.0.0.1/32"];
        login_attempts_threshold = -1;
        ip_ban_enabled = true;
        ssl_profile = "modern";
        use_x_frame_options = true;
        created_at = "2026-01-01T00:00:00+00:00";
        error = null;
        error_message = null;
      };
      pending = null;
      yaml_migration_done = true;
    };
  });
in {
  config = {
    # HA stays on the stable NixOS module, but the service itself tracks unstable.
    services.home-assistant = {
      enable = true;
      package = pkgs-unstable.home-assistant;

      # `default_config` covers onboarding; add Matter explicitly so the
      # integration is available once a Thread border router is attached.
      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "matter"
      ];

      # The NixOS submodule always materializes an `http:` block with a
      # 0.0.0.0/:: bind, which HA 2026.8+ imports once and then flags as a
      # repair. Keep the YAML minimal and put HTTP settings in the store below.
      config = null;
    };

    # Write HA's declarative YAML and user-managed HTTP store before every
    # start. The HTTP settings are infrastructure (loopback bind + Caddy proxy
    # trust), so they are declarative rather than left to the UI's
    # pending-confirm flow. HTTP settings changed in the UI are replaced on
    # restart.
    systemd.services.home-assistant.preStart = lib.mkAfter ''
      install -m 0644 ${haConfig} /var/lib/hass/configuration.yaml
      mkdir -p /var/lib/hass/.storage
      chmod 700 /var/lib/hass/.storage
      install -m 0600 ${httpStore} /var/lib/hass/.storage/http
    '';

    # Native Matter controller for HA. It can run idle until a Thread border
    # router is added; no devices need to be present for the service to start.
    services.matter-server = {
      enable = true;
      package = pkgs-unstable.python-matter-server;
      openFirewall = false;
      extraArgs = {
        listen-address = "127.0.0.1";
      };
    };

    # Keep this host's Caddy route and dashboard card beside the service itself.
    services.caddy.virtualHosts."ha.holzrussen.net".extraConfig = ''
      import cloudflare_tls
      reverse_proxy 127.0.0.1:8123
    '';

    services.homepage-dashboard.services = lib.mkBefore [
      {
        services = [
          {
            "Home Assistant" = {
              href = "https://ha.holzrussen.net";
              icon = "sh-home-assistant";
              description = "smart home hub";
            };
          }
        ];
      }
    ];
  };
}
