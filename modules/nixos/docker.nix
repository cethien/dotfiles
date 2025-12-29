{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.virtualisation.docker;
in {
  options.virtualisation.docker = {
    swarm.enable = mkEnableOption "swarm mode";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        liveRestore = !cfg.swarm.enable;
      };
    };
    networking.firewall = mkIf cfg.swarm.enable {
      allowedTCPPorts = [2377 7946 9100];
      allowedUDPPorts = [7946 4789];
    };
  };
}
