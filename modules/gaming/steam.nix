{ lib, config, ... }:

{
  options.steam.enable = lib.mkEnableOption "Enable Steam";

  config = lib.mkIf config.steam.enable {
    programs = {
      steam.enable = true;
      steam.gamescopeSession.enable = true;

      gamemode.enable = true;
    };
  };
}