{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.pokemmo;
  inherit (config.lib.deeznuts.hyprland) mkGameWindowRules;
in {
  options.programs.pokemmo.enable = mkEnableOption "pokemmo";

  config = mkIf cfg.enable {
    home.packages = [pkgs.pokemmo-installer];
    wayland.windowManager.hyprland.settings = {
      window_rule = [
        (mkGameWindowRules {title = "^(.*PokeMMO.*)$";})
      ];
    };
  };
}
