{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.services.print;
in
{
  options.deeznuts.services.print = {
    enable = mkEnableOption "Enable printing";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
  };

}
