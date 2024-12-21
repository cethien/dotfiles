{ lib, config, ... }:

{
  options.hardware.xbox-controller.enable = lib.mkEnableOption "Enable Xbox controller support";

  config = lib.mkIf config.hardware.xbox-controller.enable {
    hardware.xpadneo.enable = true;
  };
}
