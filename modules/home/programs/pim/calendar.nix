{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.pim.calendar;
in {
  options.deeznuts.programs.pim.calendar.enable = mkEnableOption "calendar";

  config = mkIf cfg.enable {
    accounts.calendar = {
      basePath = ".calendar";
    };
  };
}
