{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev.jq;
in
{
  options.deeznuts.cli.dev.jq = {
    enable = mkEnableOption "Enable jq";
  };

  config = mkIf cfg.enable {
    programs.jq.enable = true;
  };
}
