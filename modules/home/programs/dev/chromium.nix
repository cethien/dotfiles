{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.dev.chromium;
in {
  options.deeznuts.programs.dev.chromium = {
    enable = mkEnableOption "chromium browser (for development)";
  };

  config = mkIf cfg.enable {
    programs.chromium.enable = true;
    programs.chromium.package = pkgs.ungoogled-chromium;
  };
}
