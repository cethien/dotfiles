{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-net;

  net-portscan = pkgs.writeShellApplication {
    name = "net-portscan";
    runtimeInputs = with pkgs; [nmap];
    text = builtins.readFile ./net-portscan.sh;
    checkPhase = "";
  };

  net-lookup = pkgs.writeShellApplication {
    name = "net-lookup";
    runtimeInputs = with pkgs; [
      whois
      openssl
      doggo
    ];
    text = builtins.readFile ./net-lookup.sh;
    checkPhase = "";
  };

  netz-preview = pkgs.writeShellApplication {
    name = "netz-preview";
    runtimeInputs = with pkgs; [qrencode];
    text = builtins.readFile ./fzf-net-preview.sh;
    checkPhase = "";
  };
  netz = pkgs.writeShellApplication {
    name = "netz";
    runtimeInputs = with pkgs; [
      zbar
      netz-preview
    ];
    text = builtins.readFile ./fzf-net.sh;
    checkPhase = "";
  };
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
      termshark

      iperf
      speedtest-go
      net-portscan
      net-lookup

      impala
      netz
    ];

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-utils-net" =
        # lua
        ''
          Modal("netz", { binds = {
          	"SUPER + N",
          } })
        '';
    };

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
