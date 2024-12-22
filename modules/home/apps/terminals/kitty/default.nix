{ lib, config, ... }:

{
  options.apps.terminals.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf config.apps.terminals.kitty.enable {
    programs.kitty.enable = true;

    programs.kitty = {
      font.name = "CodeNewRoman Nerd Font Mono";
      font.size = 14;
    };
  };
}
