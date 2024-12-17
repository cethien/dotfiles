{ lib, config, ... }:

{
  options.user.apps.easyeffects.enable = lib.mkEnableOption "Enable easyeffects";

  config = lib.mkIf config.user.apps.easyeffects.enable {
    services.easyeffects.enable = true;
  };
}
