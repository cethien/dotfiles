{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.monitoring;
in {
  options.deeznuts.monitoring = {
    enable = mkEnableOption "monitoring";
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
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
        enable = true;
        openFirewall = true;
      };
    };

    services.cadvisor = {
      enable = true;
      port = 8080;
      listenAddress = "0.0.0.0";
      extraOptions = [
        "--docker_only"
      ];
    };

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 9080;
          gprc_listen_port = 0;
        };

        clients = [
          {
            url = "https://loki.cethien.home/loki/api/v1/push";
            tls_config.insecure_skip_verify = true;
          }
        ];

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
    systemd.tmpfiles.rules = ["d /var/lib/promtail 0755 promtail promtail -"];
    systemd.services.promtail.serviceConfig.ReadWritePaths = ["/var/lib/promtail"];

    networking.firewall = {
      allowedTCPPorts = [
        9080 # promtail
        8080 # CAdvisor
      ];
    };
  };
}
