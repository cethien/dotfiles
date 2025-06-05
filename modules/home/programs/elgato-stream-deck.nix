{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.elgato-stream-deck;
in {
  options.deeznuts.programs.elgato-stream-deck = {
    enable = mkEnableOption "elgato stream deck (enabled in OS, manage profiles and autstart)";
    hyprland.autostart.enable = mkEnableOption "hyprland autostart";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] streamcontroller -b"
      ];
    };
  };
}
