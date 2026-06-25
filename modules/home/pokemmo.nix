{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.pokemmo;
in {
  options.programs.pokemmo.enable = mkEnableOption "pokemmo";

  config = mkIf cfg.enable {
    home.packages = [pkgs.pokemmo-installer];
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-pokemmo" =
        #lua
        ''
          game_windowrule({ title = "^(.*PokeMMO.*)$" })
        '';
    };
  };
}
