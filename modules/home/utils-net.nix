{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.programs.netUtils;
in {
  options.programs.netUtils = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      wget

      iproute2
      nettools

      nmap
      dig
      tcpdump
      dhcpdump
      iperf
      mtr
      iftop
      nethogs
      bmon
      arp-scan
      whois
      tshark
      termshark
    ];

    home.shellAliases = {
      speedtest = "${pkgs.speedtest-go}/bin/speedtest-go";
    };
  };
}
