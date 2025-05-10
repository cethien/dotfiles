{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
  cfg = config.deeznuts.programs.hyprland;
in
{
  imports = [
    ./clipse
    ./common-gui
    ./zathura
    ./hypridle
    ./hyprlock
    ./hyprpaper
    ./hyprpanel
    ./hyprshot
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      hyprpicker
      udiskie
    ];

    deeznuts.programs = {
      clipse.enable = mkDefault true;
      common-gui.enable = mkDefault true;
      zathura.enable = mkDefault true;
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "solaar -w hide"
        "streamcontroller -b"
        "udiskie"
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
