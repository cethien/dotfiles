{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.virtualisation.waydroid;
in {
  options.deeznuts.virtualisation.waydroid = {
    enable = mkEnableOption "android emulation";
  };

  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;
  };
}
