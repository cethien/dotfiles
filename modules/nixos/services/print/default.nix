{ lib, config, ... }:

{
  options.deeznuts.services.print.enable = lib.mkEnableOption "Enable print server";

  config = lib.mkIf config.deeznuts.services.print.enable {
    services.printing.enable = true;
  };

}
