{ lib, config, ... }:
{
  config = lib.mkIf config.desktop-environment.hyprland.enable {
    wayland.windowManager.hyprland.settings.exec-once = [
      "waybar"
      "spotify --minimized"
      "discordcanary --start-minimized"
      "steam -silent"
      "firefox"
    ];
  };
}
