{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.chromium;
in
{
  options.deeznuts.programs.chromium = {
    enable = mkEnableOption "Chromium browser (for development)";
  };

  config = mkIf cfg.enable {
    programs.chromium.enable = true;
  };
}
