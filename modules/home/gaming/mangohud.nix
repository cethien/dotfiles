{ lib, config, ... }:

{
  options.gaming.mangohud.enable = lib.mkEnableOption "Enable mangohud";

  config = lib.mkIf config.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
      };
    };
  };
}
