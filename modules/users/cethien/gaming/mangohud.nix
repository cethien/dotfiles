{ lib, config, ... }:

{
  options.user.gaming.mangohud.enable = lib.mkEnableOption "Enable mangohud";

  config = lib.mkIf config.user.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        fps_only = true;
      };
    };
  };
}
