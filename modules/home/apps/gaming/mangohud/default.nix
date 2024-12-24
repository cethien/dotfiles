{ lib, config, ... }:

{
  options.deeznuts.apps.gaming.mangohud.enable = lib.mkEnableOption "Enable mangohud";

  config = lib.mkIf config.deeznuts.apps.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
      };
    };
  };
}
