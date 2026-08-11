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

    programs.tmux.launcher.settings.entries = [
      {
        icon = "󰇖";
        name = "lookup domain";
        exec = "net-lookup";
        hold = true;
        preview_text = ''
          # Domain Lookup Utility

          Gathers DNS entries, WHOIS records, and TLS certificate info.

          ### Included Checks:
          - **DNS Records:** A, AAAA, MX, TXT (via `doggo`)
          - **WHOIS:** Registrar & Expiry Date
          - **SSL/TLS:** Certificate details & validity
        '';
      }
      {
        icon = "󰈈";
        name = "portscan";
        exec = "net-portscan";
        hold = true;
        preview_text = ''
          # Interactive Port Scanner

          Runs guided target selection and scans network hosts.

          ### Underlying Engine:
          Uses **nmap** to quickly detect open TCP/UDP ports and active network services.
        '';
      }
      {
        icon = "󰏔";
        name = "trace packet routes";
        exec = "trip $(${pkgs.gum}/bin/gum input --prompt='trace target: ')";
        preview_text = ''
          # Packet Route Tracer (`trippy`)

          Interactive terminal network diagnostic tool (traceroute + ping).

          ```bash
          $ trip <host/IP>
          ```
        '';
      }
      {
        icon = "󰓅";
        name = "speedtest";
        exec = "speedtest-go";
        hold = true;
        preview_text = ''
          # Speedtest CLI

          Measures latency, download, and upload speeds via Ookla servers using `speedtest-go`.
        '';
      }
      {
        icon = "󰾆";
        name = "bandwidth test";
        exec = "iperf3 -c speedtest.wtnet.de -p 5200 -P 10 -4 -R";
        hold = true;
        preview_text = ''
          # Wilhelm.Tel iPerf3 Benchmark

          Runs a parallel multi-stream throughput test against wilhelm.tel infrastructure.

          - **Target Host:** `speedtest.wtnet.de`
          - **Parameters:** 10 parallel streams, IPv4, Reverse mode
          - **Website:** [https://speedtest.wtnet.de](https://speedtest.wtnet.de)
        '';
      }
    ];
  };
}
