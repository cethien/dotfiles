{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.terminals.kitty;
in
{
  options.deeznuts.terminals.kitty = {
    enable = mkEnableOption "Enable kitty terminal";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font.name = "MesloLGM Nerd Font Mono";
      font.size = 14;
    };
  };
}
