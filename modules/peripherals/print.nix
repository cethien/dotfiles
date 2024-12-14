{ lib, config, ... }:

{
  options.peripherals.print.enable = lib.mkEnableOption "Enable printing";

  config = lib.mkIf config.peripherals.print.enable {
    services.printing.enable = true;
  };

}