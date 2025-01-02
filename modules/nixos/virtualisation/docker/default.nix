{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) bool str listOf passwdEntry;
  cfg = config.deeznuts.virtualisation.docker;
in
{
  options.deeznuts.virtualisation.docker = {
    enable = mkEnableOption "Enable docker";
    liveRestore = mkOption {
      type = bool;
      default = false;
      description = "Enable live restore";
    };

    users = mkOption {
      type = listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can use docker";
    };

    swarm.firewallPorts = {
      enable = mkEnableOption "Enable firewall ports for swarm";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    virtualisation.docker.liveRestore = cfg.liveRestore;

    users.extraGroups.docker.members = cfg.users;

    networking.firewall = mkIf cfg.swarm.firewallPorts.enable {
      allowedTCPPorts = [ 2377 7946 9100 ];
      allowedUDPPorts = [ 7946 4789 ];
    };
  };
}
