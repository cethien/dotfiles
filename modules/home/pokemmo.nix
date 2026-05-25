{
  lib,
  config,
  pkgs,
  ...
}: let
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
  cfg = config.programs.pokemmo;
in {
  options.programs.pokemmo.enable = lib.mkEnableOption "pokemmo";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.pokemmo-installer];

    wayland.windowManager.hyprland.settings.windowrule =
      config.lib.deeznuts.mkHyprGameWindowRules [
        "match:title ^(.*PokeMMO.*)$"
      ]
      ws;
  };
}
