{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  enable = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    home.packages = with pkgs; [
      wl-clipboard
      clipse
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [ "clipse -listen" ];

      bind = [
        "SUPER SHIFT, V, exec, $terminal --class clipse clipse"
      ];
    };
  };
}
