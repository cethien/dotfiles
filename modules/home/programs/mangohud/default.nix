{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.mangohud;
in

{
  options.deeznuts.programs.mangohud = {
    enable = mkEnableOption "Enable mangohud";
  };

  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
        fps_limit = 240;
        vsync = 0;
        glvsync = -1;
      };
    };
  };
}
