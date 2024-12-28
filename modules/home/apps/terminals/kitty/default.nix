{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.terminals.kitty;
in
{
  options.deeznuts.apps.terminals.kitty = {
    enable = mkEnableOption "Enable kitty terminal";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font.name = "CodeNewRoman Nerd Font Mono";
      font.size = 14;
    };
  };
}
