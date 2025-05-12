{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
  cfg = config.deeznuts.programs.hyprland;
  enabled = cfg.enable;
in
{
  imports = [
    ./kitty
    ./waybar
    ./rofi
    ./clipse
    ./common-gui
    ./zathura
    ./hypridle
    ./hyprlock
    ./hyprpaper
    ./hyprpanel
    ./hyprshot
    ./wf-recorder
  ];

  config = mkIf enabled {
    home.packages = with pkgs; [
      brightnessctl
      hyprpicker
      udiskie
    ];

    deeznuts.programs = {
      hyprpaper.enable = mkDefault true;
      hyprpanel.enable = mkDefault true;
      # waybar.enable = mkDefault true;

      kitty.enable = mkDefault true;
      rofi.enable = mkDefault true;
      clipse.enable = mkDefault true;
      common-gui.enable = mkDefault true;
      zathura.enable = mkDefault true;
      wf-recorder.enable = mkDefault true;
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
