{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces;
  cfg = config.programs.heroic;
in {
  options.programs.heroic.enable = mkEnableOption "heroic launcher";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      protonplus
      heroic
    ];

    wayland.windowManager.hyprland.settings = {
      windowrule = let
        heroic = [
          "NTE"
        ];
      in (config.lib.deeznuts.mkHyprGameWindowRules (
          map (g: "match:initial_class steam_app_default, match:initial_title ${g}") heroic
        )
        ws.gaming);
    };
  };
}
