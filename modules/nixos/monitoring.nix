{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault;
in {
  config = {
    services.prometheus.exporters = {
      node = {
        enable = mkDefault false;
        openFirewall = true;
        enabledCollectors = [
          "cpu"
          "meminfo"
          "diskstats"
          "filesystem"
          "netstat"
          "systemd" # lightweight, high-level
          "processes"
          "loadavg"
          "time"
          "uname"
          "stat"
          "entropy"
          "textfile"
        ];
      };

      systemd = {
        enable = mkDefault false;
        openFirewall = true;
      };
    };

    services.cadvisor = {
      enable = mkDefault false;
      port = 8080;

      listenAddress = "0.0.0.0";
      extraOptions = [
        "--docker_only"
      ];
    };

    services.promtail = {
      enable = mkDefault false;
      configuration = {
        server = {
          http_listen_port = 9080;
          gprc_listen_port = 0;
        };

        positions = {
          filename = "/var/lib/promtail/positions.yaml";
        };

        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = "nixos";
              };
            };

            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };

    systemd.tmpfiles.rules = mkIf config.services.promtail.enable [
      "d /var/lib/promtail 0755 promtail promtail -"
    ];
    systemd.services.promtail.serviceConfig.ReadWritePaths = mkIf config.services.promtail.enable [
      "/var/lib/promtail"
    ];

    networking.firewall = {
      allowedTCPPorts = mkMerge [
        (mkIf config.services.promtail.enable [9080])
        (mkIf config.services.cadvisor.enable [8080])
      ];
    };
  };
}
