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
    services = {
      prometheus.exporters = {
        node = {
          enable = true;
          openFirewall = true;
          enabledCollectors = [
            "processes"
          ];
        };

        systemd = {
          enable = true;
          openFirewall = true;
        };

        wireguard = {
          enable = true;
          openFirewall = true;
        };
      };

      cadvisor.enable = true;

      # TODO: need local dns settings for this.
      # otherwise domain resolution wont work
      # promtail.enable = true;
    };

    networking.firewall = {
      allowedTCPPorts = [
        8080 #CAdvisor
      ];
    };
  };
}
