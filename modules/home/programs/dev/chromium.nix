{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.chromium;
in {
  options.deeznuts.programs.chromium = {
    enable = mkEnableOption "chromium browser (for development)";
  };

  config = mkIf cfg.enable {
    programs.chromium.enable = true;
    programs.chromium.package = pkgs.ungoogled-chromium;
  };
}
