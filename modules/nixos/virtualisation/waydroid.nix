{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.virtualisation.waydroid;
in {
  options.deeznuts.virtualisation.waydroid = {
    enable = mkEnableOption "android emulation";
  };

  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;
  };
}
