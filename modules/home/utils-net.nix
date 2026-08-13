{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.utils-net;
  inherit (config.lib.deeznuts) mkArgcBashBin;

  sitecheck = mkArgcBashBin {
    src = ./sitecheck.sh;
    extraRuntimeDeps = with pkgs; [
      jq
      whois
      openssl
      doggo
      curl
    ];
  };

  bandwidth = pkgs.writeShellScriptBin "bandwidth" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      iperf3
      gum
      coreutils
    ])}:$PATH"

    ${builtins.readFile ./bandwidth.sh}
  '';

  pscan = pkgs.writeShellScriptBin "pscan" ''
    export PATH="${pkgs.lib.makeBinPath (with pkgs; [
      nmap
    ])}:$PATH"

    ${builtins.readFile ./pscan.sh}
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
      iftop
      nethogs
      nmap
      whois
      doggo
      termshark
      iperf
      speedtest-go
      bandwidth
      pscan
      sitecheck
    ];
  };
}
