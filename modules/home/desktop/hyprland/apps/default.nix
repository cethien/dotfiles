{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./hyprpaper.nix
    ./hyprpanel.nix
    ./rofi.nix

    ./hyprlock.nix
    ./hypridle.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      playerctl

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
        "1, name:general, monitor:DP-1, persistent:true, default:false"
        "2, name:gaming, monitor:DP-1, persistent:true, default:false"

        "3, name:browser, monitor:HDMI-A-1, persistent:true, default:false"
        "4, name:spotify, monitor:HDMI-A-1, persistent:true, default:false"
        "5, name:discord, monitor:HDMI-A-1, persistent:true, default:false"
      ];

      exec-once = [
        "steam -silent"
        "solaar -w hide"

        "[workspace 1 silent] code"

        "[workspace 3 silent] zen"
        "[workspace 4 silent] spotify"
        "[workspace 5 silent] discordcanary"
      ];

      "$terminal" = "kitty";
      "$fileManager" = "kitty yazi";
      "$menu" = "rofi -show drun";

      bind = [
        # scroll through existing workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod CTRL, left, workspace, e-1"
        "$mainMod CTRL, right, workspace, e+1"

        "$mainMod, R, exec, $menu"
        "$mainMod, SPACE, exec, $menu"

        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $fileManager"

        "$mainMod SHIFT, C, exec, hyprpicker -a"

        "$mainMod SHIFT, S, exec, hyprshot -m region"
        ", Print, exec, hyprshot -m window"
      ];

      "$spotifyctl" = "playerctl --player=spotify";

      bindl = [
        ", XF86AudioRaiseVolume, exec, $spotifyctl volume 0.05+"
        ", XF86AudioLowerVolume, exec, $spotifyctl volume 0.05-"

        ", XF86AudioNext, exec, $spotifyctl next"
        ", XF86AudioPrev, exec, $spotifyctl previous"
        ", XF86AudioPlay, exec, $spotifyctl play-pause"
        ", XF86AudioPause, exec, $spotifyctl play-pause"

        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      # https://wiki.hyprland.org/Configuring/Window-Rules/
      windowrulev2 = [
        "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
      ];
    };
  };
}
