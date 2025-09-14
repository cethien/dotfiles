{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.virtualisation.docker;
in {
  options.deeznuts.virtualisation.docker = {
    enable = mkEnableOption "docker";
    users = mkOption {
      type = types.listOf (types.passwdEntry types.str);
      default = [];
      description = "List of users that can use docker";
    };

    swarm.enable = mkEnableOption "swarm mode";
    swarm.firewall.enable = mkOption {
      type = types.bool;
      default = cfg.swarm.enable;
      description = "enables firewall ports that are needed so swarm nodes can talk to each other";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        liveRestore = !cfg.swarm.enable;
      };
    };
    users.extraGroups.docker.members = cfg.users;
    networking.firewall = mkIf cfg.swarm.firewall.enable {
      allowedTCPPorts = [2377 7946 9100];
      allowedUDPPorts = [7946 4789];
    };
  };
}
