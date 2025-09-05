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
    programs.tmux.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        compression = true;
        forwardAgent = true;
        hashKnownHosts = true;
      };
    };
  };
}
