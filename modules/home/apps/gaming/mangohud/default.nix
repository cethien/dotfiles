{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.gaming.mangohud;
in

{
  options.deeznuts.apps.gaming.mangohud = {
    enable = mkEnableOption "Enable mangohud";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
      };
    };
  };
}
