{ lib, config, ... }:

{
  options.deeznuts.apps.easyeffects.enable = lib.mkEnableOption "Enable easyeffects";

  config = lib.mkIf config.deeznuts.apps.easyeffects.enable {
    services.easyeffects.enable = true;
  };
}
