{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts.hyprland) mkGameWindowRules;
  cfg = config.programs.heroic;
in {
  options.programs.heroic.enable = mkEnableOption "heroic launcher";

  config = mkIf cfg.enable {
    home.packages = [pkgs.heroic];

    wayland.windowManager.hyprland.settings = {
      windowrule = let
        games = [
          "NTE"
        ];
        gameMatches =
          map (g: "match:initial_class steam_app_default, match:initial_title ${g}") games;
      in
        mkGameWindowRules gameMatches;
    };
  };
}
