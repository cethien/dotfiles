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
      window_rule = [
        (mkGameWindowRules {
          initial_class = "steam_app_default";
          initial_title = "^(NTE)$";
        })
      ];
    };
  };
}
