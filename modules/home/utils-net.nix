{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-net;
in {
  options.programs.utils-net.enable = lib.mkEnableOption "network utilities";

  config = lib.mkIf cfg.enable {
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
      (pkgs.writeShellScriptBin "netz" (builtins.readFile ./fzf-net.sh))
    ];

    wayland.windowManager.hyprland.modals."netz".binds = ["SUPER + N"];

    programs.tmux.keybindings = [
      {
        key = ",";
        action = ''display-popup -w 60% -h 60% -E "netz"'';
      }
    ];
  };
}
