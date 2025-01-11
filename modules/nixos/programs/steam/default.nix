{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.steam;
in
{
  options.deeznuts.programs.steam = {
    enable = mkEnableOption "Enable steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
