{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-net;

  net-portscan = pkgs.writeShellScriptBin "net-portscan" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      nmap
    ])}:$PATH"

    ${builtins.readFile ./net-portscan.sh}
  '';

  net-lookup = pkgs.writeShellScriptBin "net-lookup" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      whois
      openssl
      doggo
      jq
      curl
    ])}:$PATH"

    ${builtins.readFile ./net-lookup.sh}
  '';
in {
  options.programs.utils-net.enable = lib.mkEnableOption "network utilities";

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      trip = "/run/wrappers/bin/trip";
      arp-scan = "/run/wrappers/bin/arp-scan";
    };

    home.packages = with pkgs; [
      curl
      wget

      ethtool
      # bmon
      iftop
      nethogs
      nmap
      whois
      doggo
      termshark

      iperf
      speedtest-go
      net-portscan
      net-lookup
    ];

    programs.tmux.launcher.entries = [
      {
        icon = "󰇖";
        name = "lookup domain";
        exec = "net-lookup";
        hold = true;
      }
      {
        icon = "󰈈";
        name = "portscan";
        exec = "net-portscan";
        hold = true;
      }
      {
        icon = "󰏔";
        name = "trace packet routes";
        exec = "trip $(${pkgs.gum}/bin/gum input --prompt='trace target: ')";
      }
      {
        icon = "󰓅";
        name = "speedtest";
        exec = "speedtest-go";
        hold = true;
      }
      {
        icon = "󰾆";
        name = "bandwith test [speedtest.wtnet.de]";
        exec = "iperf3 -c speedtest.wtnet.de -p 5200 -P 10 -4 -R";
        hold = true;
      }
    ];
  };
}
