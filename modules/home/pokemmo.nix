{
  lib,
  config,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.pokemmo;
in {
  options.programs.pokemmo.enable = mkEnableOption "pokemmo";

  config = mkIf cfg.enable {
    home.packages = [
      # pkgs-unstable.pokemmo
    ];
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-pokemmo" =
        #lua
        ''
          game_windowrule({ title = "^(.*PokeMMO.*)$" })
        '';
    };
  };
}
