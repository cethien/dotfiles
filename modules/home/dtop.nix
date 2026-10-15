{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf;
  cfg = config.programs.dtop;

  yamlFormat = pkgs.formats.yaml {};
in {
  options.programs.dtop = {
    enable = mkEnableOption "dtop";
    package = mkPackageOption pkgs "dtop" {};
    settings = lib.mkOption {
      type = yamlFormat.type;
      default = {};
      description = "Configuration for dtop.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."dtop/config.yaml" = mkIf (cfg.settings != {}) {
      source = yamlFormat.generate "dtop-config.yaml" cfg.settings;
    };
  };
}
