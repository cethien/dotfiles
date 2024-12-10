{ lib, config, ... }:

{
  options.gaming.steam.enable = lib.mkEnableOption "Enable Steam";

  config = lib.mkIf config.gaming.steam.enable {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;
  };
}