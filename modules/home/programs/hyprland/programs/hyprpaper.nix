{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.hyprpaper;
  enabled = cfg.enable;
in {
  options.deeznuts.programs.hyprpaper.enable = mkEnableOption "hyprpaper";

  config = mkIf enabled {
    services.hyprpaper.enable = true;
  };
}
