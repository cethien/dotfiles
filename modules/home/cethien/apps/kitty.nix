{ lib, config, ... }:

{
  options.user.apps.kitty.enable = lib.mkEnableOption "Enable kitty terminal";

  config = lib.mkIf config.user.apps.kitty.enable {
    programs.kitty.enable = true;

    programs.kitty = {
      font.name = "CodeNewRoman Nerd Font Mono";
      font.size = 14;
    };
  };
}
