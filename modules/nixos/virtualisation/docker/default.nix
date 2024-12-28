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

    swarmFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open firewall ports for docker swarm";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.liveRestore = cfg.liveRestore;
    users.extraGroups.docker.members = cfg.users;

    networking.firewall.allowedTCPPorts =
      if cfg.swarmFirewall then
        [ 2377 7946 9100 ] else
        [ ];
    networking.firewall.allowedUDPPorts =
      if cfg.swarmFirewall then
        [ 7946 4789 ] else
        [ ];
  };
}
