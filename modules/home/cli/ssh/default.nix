{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.ssh;
in
{
  options.deeznuts.cli.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      compression = true;
      forwardAgent = true;
      hashKnownHosts = true;
    };
  };
}
