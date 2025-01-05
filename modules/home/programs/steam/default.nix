{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.steam;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.steam = {
    enable = mkEnableOption "Enable Steam Options (steam itself must be enabled on nixos)";
  };

  config = mkIf (cfg.enable && isHyprland) {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "steam -silent"
      ];

      windowrulev2 = [
        "float, class:(steam)"
        "center, class:(steam)"
        "size 1640 990, class:(steam)"
      ];
    };
  };
}
