{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.deeznuts.programs.essentials;
in {
  imports = [
    ./tmux
  ];

  options.deeznuts.programs.essentials = {
    enable = mkEnableOption "essential utils tools";
  };

  config = mkIf cfg.enable {
    programs = {
      tmux.enable = true;
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = mkDefault {
            compression = true;
            forwardAgent = true;
            hashKnownHosts = true;
          };
        };
      };
      tmux.resurrectPluginProcesses = ["ssh"];
    };
  };
}
