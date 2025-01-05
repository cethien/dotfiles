{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./hyprpaper
    ./hyprpanel
    ./hyprlock
    ./hypridle
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl

      clipse
      hyprpicker
      hyprshot
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "clipse -listen"

        "solaar -w hide"
        "streamcontroller"
      ];

      bind = [
        "SUPER, E, exec, $terminal --class yazi yazi"

        "SUPER SHIFT, V, exec, $terminal --class clipse clipse"

        "SUPER SHIFT, C, exec, hyprpicker -a"

        "SUPER SHIFT, S, exec, hyprshot -m region"
        ", Print, exec, hyprshot -m window"
      ];

      bindl = [
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
  };
}
