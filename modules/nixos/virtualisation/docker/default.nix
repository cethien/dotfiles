{ lib, config, ... }:

{
  options.deeznuts.virtualisation.docker = {
    enable = lib.mkEnableOption "Enable docker";
    liveRestore = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable live restore";
    };

    users = lib.mkOption {
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can use docker";
    };

    swarmFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open firewall ports for docker swarm";
    };
  };

  config = lib.mkIf config.deeznuts.virtualisation.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.liveRestore = config.deeznuts.virtualisation.docker.liveRestore;
    users.extraGroups.docker.members = config.deeznuts.virtualisation.docker.users;

    networking.firewall.allowedTCPPorts =
      if config.deeznuts.virtualisation.docker.swarmFirewall then
        [ 2377 7946 9100 ] else
        [ ];
    networking.firewall.allowedUDPPorts =
      if config.deeznuts.virtualisation.docker.swarmFirewall then
        [ 7946 4789 ] else
        [ ];
  };
}
