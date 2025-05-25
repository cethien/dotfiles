{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.easyeffects;
in
{
  options.deeznuts.programs.easyeffects = {
    enable = mkEnableOption "Enable easyeffects";
  };

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
  };
}
