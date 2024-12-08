{ lib, config, ... }:

{
  options.gaming.steam.enable = lib.mkEnableOption "Enable Steam";

  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      steam.enable = true;
      steam.gamescopeSession.enable = true;

      gamemode.enable = true;
    };
  };
}