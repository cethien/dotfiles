{ lib, config, ... }:

{
  options.services.print.enable = lib.mkEnableOption "Enable print server";

  config = lib.mkIf config.services.print.enable {
    services.printing.enable = true;
  };

}
