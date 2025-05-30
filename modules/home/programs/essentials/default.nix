{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.essentials;
in {
  imports = [
    ./tmux
  ];

  options.deeznuts.programs.essentials = {
    enable = mkEnableOption "essential utils tools";
  };

  config = mkIf cfg.enable {
    services.ssh-agent.enable = true;
    programs = {
      ssh.enable = true;
      ssh = {
        compression = true;
        forwardAgent = true;
        hashKnownHosts = true;
      };
      tmux.enable = true;
    };
  };
}
