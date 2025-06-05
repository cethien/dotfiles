{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) bool str listOf passwdEntry;
  cfg = config.deeznuts.docker;
in {
  options.deeznuts.docker = {
    enable = mkEnableOption "docker";
    users = mkOption {
      type = listOf (passwdEntry str);
      default = [];
      description = "List of users that can use docker";
    };

    swarm.enable = mkEnableOption "swarm mode";
    swarm.firewall.enable = mkOption {
      type = bool;
      default = cfg.swarm.enable;
      description = "enables firewall ports that are needed so swarm nodes can talk to each other";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = cfg.users;
    virtualisation.docker.liveRestore = cfg.swarm.enable;
    networking.firewall = mkIf cfg.swarm.firewall.enable {
      allowedTCPPorts = [2377 7946 9100];
      allowedUDPPorts = [7946 4789];
    };
  };
}
