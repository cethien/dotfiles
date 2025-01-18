{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./clipse
    ./hypridle
    ./hyprlock
    ./hyprpaper
    ./hyprpanel
    ./satty
    ./nautilus
    ./udiskie
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl

      hyprpicker
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "solaar -w hide"
        "streamcontroller -b"
      ];

      bind = [
        "SUPER SHIFT, C, exec, hyprpicker -a"
      ];

      bindl = [
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
  };
}
