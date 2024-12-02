{ lib,config, ... }:

{
  options.xbox.enable = lib.mkEnableOption "Enable Xbox controller support";

  config = lib.mkIf config.xbox.enable {
    hardware.xpadneo.enable = true;
  };
}