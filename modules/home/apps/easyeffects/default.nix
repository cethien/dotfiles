{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.easyeffects;
in
{
  options.deeznuts.apps.easyeffects = {
    enable = mkEnableOption "Enable easyeffects";
  };

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
  };
}
