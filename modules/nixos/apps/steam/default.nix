{ lib, config, ... }:

{
  options.deeznuts.apps.steam.enable = lib.mkEnableOption "Enable Steam";

  config = lib.mkIf config.deeznuts.apps.steam.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
