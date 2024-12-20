{ lib, config, ... }:

{
  options.apps.easyeffects.enable = lib.mkEnableOption "Enable easyeffects";

  config = lib.mkIf config.apps.easyeffects.enable {
    services.easyeffects.enable = true;
  };
}
