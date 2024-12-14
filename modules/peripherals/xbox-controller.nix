{ lib,config, ... }:

{
  options.peripherals.xbox-controller.enable = lib.mkEnableOption "Enable Xbox controller support";

  config = lib.mkIf config.peripherals.xbox-controller.enable {
    hardware.xpadneo.enable = true;
  };
}