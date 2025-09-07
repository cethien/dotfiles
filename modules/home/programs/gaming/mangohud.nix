{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.gaming.mangohud;
in {
  options.deeznuts.programs.gaming.mangohud = {
    enable = mkEnableOption "Enable mangohud";
  };

  config = mkIf cfg.enable {
    stylix.targets.mangohud.enable = false;
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
        fps_limit = 240;
      };
    };
  };
}
