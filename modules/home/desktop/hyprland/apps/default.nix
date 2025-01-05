{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./hyprpaper
    ./hyprpanel
    ./rofi

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
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 0x1440, 1"
      ];

      # https://wiki.hyprland.org/Configuring/Workspace-Rules/
      workspace = [
        "1, monitor:DP-1, persistent:true, default:false"
        "r[2-5], monitor:DP-1, persistent:true, default:true"

        "10, monitor:HDMI-A-1, persistent:true, default:true"
        "11, monitor:HDMI-A-1, persistent:true, default:false"
        "12, monitor:HDMI-A-1, persistent:true, default:false"
      ];

      exec-once = [
        "clipse -listen"

        "solaar -w hide"
        "streamcontroller"
      ];

      bind = [
        # scroll through existing workspaces
        "SUPER CTRL, right, workspace, e+1"
        "SUPER CTRL, left, workspace, e-1"

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
