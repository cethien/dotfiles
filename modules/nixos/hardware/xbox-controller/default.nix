{ lib, config, ... }:

{
  options.deeznuts.hardware.xbox-controller.enable = lib.mkEnableOption "Enable Xbox controller support";

  config = lib.mkIf config.deeznuts.hardware.xbox-controller.enable {
    hardware.xpadneo.enable = true;
  };
}
