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
    programs = {
      trippy.enable = true;
    };

    home.packages = with pkgs; [
      curl
      wget
      iproute2
      nettools
      nmap
      rustscan
      dig
      doggo
      tcpdump
      dhcpdump
      iperf
      mtr
      iftop
      nethogs
      bmon
      arp-scan
      fping
      tshark
      termshark
      speedtest-go
      whois
      (pkgs.writeShellScriptBin "net-lookup" (builtins.readFile ./net-lookup.sh))
      (pkgs.writeShellScriptBin "net-scan" (builtins.readFile ./net-scan.sh))
      (pkgs.writeShellScriptBin "fzf-net" (builtins.readFile ./fzf-net.sh))
    ];

    wayland.windowManager.hyprland.modals."fzf-net".bind = "SUPER, N";
  };
}
