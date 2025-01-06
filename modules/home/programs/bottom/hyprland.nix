{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfd = config.deeznuts.programs.bottom;
  enable = cfd.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, P, exec, $terminal --class bottom btm"
      ];
    };
  };
}
