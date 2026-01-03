{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.deeznuts.net-tools;
in {
  options.deeznuts.net-tools = {
    enable = lib.mkEnableOption "Enable capability wrappers for network tools";
  };

  config = lib.mkIf cfg.enable {
    users.groups.nettools = {};

    security.wrappers = {
      ping = {
        owner = "root";
        group = "nettools";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.iputils.out}/bin/ping";
      };

      trippy-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o="; # Only owner (root) and group (nettools) can execute
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.trippy}/bin/trip";
      };

      tshark-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin=ep";
        source = "${pkgs.tshark}/bin/dumpcap";
      };

      termshark-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin+eip";
        source = "${pkgs.termshark}/bin/termshark";
      };
    };
  };
}
