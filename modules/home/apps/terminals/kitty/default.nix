{ lib, config, ... }:

{
  options.deeznuts.apps.terminals.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf config.deeznuts.apps.terminals.kitty.enable {
    programs.kitty.enable = true;

    programs.kitty = {
      font.name = "CodeNewRoman Nerd Font Mono";
      font.size = 14;
    };
  };
}
