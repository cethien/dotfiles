{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.net;
in {
  options.deeznuts.programs.net = {
    enable = mkEnableOption "common network utilities";
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
  };
}
