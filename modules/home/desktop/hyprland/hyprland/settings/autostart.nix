{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = [
      "waybar"
      "spotify --minimized"
      "discordcanary --start-minimized"
      "steam -silent"
      "firefox"
    ];
  };
}
