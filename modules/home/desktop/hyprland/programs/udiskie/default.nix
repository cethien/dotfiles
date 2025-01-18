{ config, lib, ... }:
let
  inherit (lib) mkIf;
  enable = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    services.udiskie.enable = true;

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "udiskie"
      ];
    };
  };
}
