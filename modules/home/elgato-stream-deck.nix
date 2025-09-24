{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption elem;
  cfg = config.deeznuts.programs.elgato-stream-deck;
  hypr = elem "elgato-stream-deck" config.wayland.windowManager.hyprland.autostart;
in {
  options.deeznuts.programs.elgato-stream-deck = {
    enable = mkEnableOption "elgato stream deck (enabled in OS, manage profiles and autstart)";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr [
        "[silent] streamcontroller -b"
      ];
    };
  };
}
