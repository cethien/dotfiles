{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-net;

  netz-preview = pkgs.writeShellApplication {
    name = "netz-preview";
    runtimeInputs = with pkgs; [qrencode];
    text = builtins.readFile ./fzf-net-preview.sh;
    checkPhase = "";
  };

  net-scan = pkgs.writeShellApplication {
    name = "net-scan";
    runtimeInputs = with pkgs; [rustscan];
    text = builtins.readFile ./net-scan.sh;
    checkPhase = "";
  };

  net-lookup = pkgs.writeShellApplication {
    name = "net-lookup";
    runtimeInputs = with pkgs; [doggo whois openssl];
    text = builtins.readFile ./net-lookup.sh;
    checkPhase = "";
  };

  netz = pkgs.writeShellApplication {
    name = "netz";
    runtimeInputs = with pkgs; [
      zbar
      net-scan
      net-lookup
      netz-preview
    ];
    text = builtins.readFile ./fzf-net.sh;
    checkPhase = "";
  };
in {
  options.programs.utils-net.enable = lib.mkEnableOption "network utilities";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      wget
      iproute2
      nettools
      nmap
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
      impala

      netz
      net-scan
      net-lookup
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

    programs.tmux.keybindings = [
      {
        key = ",";
        action = "new-window -n 'networking' '${netz}/bin/netz'";
      }
    ];
  };
}
