{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 640x1440, 1"
      ];

      exec-once = [
        "[workspace 1 silent] kitty btm"
        "[workspace 2 silent] code"

        "[workspace 4 silent] zen"
        "[workspace 5 silent] spotify"
        "[workspace 6 silent] discordcanary"
      ];

      # https://wiki.hyprland.org/Configuring/Workspace-Rules/
      workspace = [
        "1, name:monitor, monitor:DP-1, persistent:true, default:false"
        "2, name:dev, monitor:DP-1, persistent:true, default:false"
        "3, name:gaming, monitor:DP-1, persistent:true, default:false"

        "4, name:browser, monitor:HDMI-A-1, persistent:true, default:false"
        "5, name:spotify, monitor:HDMI-A-1, persistent:true, default:false"
        "6, name:discord, monitor:HDMI-A-1, persistent:true, default:false"
      ];

      bind = [
        # scroll through existing workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod CTRL, left, workspace, e-1"
        "$mainMod CTRL, right, workspace, e+1"
      ];

      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = [
        "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
      ];
    };
  };

}
