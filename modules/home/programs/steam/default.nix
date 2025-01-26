{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.deeznuts.programs.steam;
  isHyprland = config.deeznuts.desktop.hyprland.enable;
  enabled = cfg.enable || (isHyprland && cfg.enable != false);
in
{
  options.deeznuts.programs.steam = {
    enable = mkEnableOption "Enable Steam Options (steam itself must be enabled on nixos / installed on distro)";
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "steam autostart";
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart [
        "steam -silent"
      ];
    };
  };
}
