# TODO: this only exists cuz i dont have any means to set on network level yet
{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.homelab;

  hostIp = "192.168.0.23";
  baseDomain = "cethien.home";
  subdomains = [
    "portainer"
    "grafana"
  ];

  baseDomainEntry = "${hostIp} ${baseDomain}";
  subDomainEntries = map (sub: "${hostIp} ${sub}.${baseDomain}") subdomains;
  entries = lib.concatStringsSep "\n" ([baseDomainEntry] ++ subDomainEntries);
in {
  options.deeznuts.homelab = {
    enable = mkEnableOption "homelab stuff";
  };

  config = mkIf cfg.enable {
    networking.extraHosts = entries;
  };
}
