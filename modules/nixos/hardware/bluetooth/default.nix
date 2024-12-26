{ lib, config, ... }:
{
  options.deeznuts.hardware.bluetooth.enable = lib.mkEnableOption "Enable bluetooth hardware";

  config = lib.mkIf config.deeznuts.hardware.bluetooth.enable {
    hardware.bluetooth.enable = true;
  };
}
