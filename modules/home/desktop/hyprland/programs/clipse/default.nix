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

      windowrulev2 = [
        "float, class:^(clipse)$"
        "center, class:^(clipse)$"
        "size 1640 990, class:^(clipse)$"
        "stayfocused, class:^(clipse)$"
      ];
    };
  };
}
