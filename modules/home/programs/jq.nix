{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.jq;
in
{
  options.deeznuts.programs.jq = {
    enable = mkEnableOption "Enable jq";
  };

  config = mkIf cfg.enable {
    programs.jq.enable = true;
  };
}
