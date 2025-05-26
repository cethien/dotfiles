{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.deeznuts.programs.hyprland;
  enabled = config.deeznuts.programs.hyprland.enable;
in {
  options.deeznuts.programs.hyprland = {
    monitors = mkOption {
      type = types.listOf types.str;
      default = [
        "eDP-1, 1920x1080@60, 0x0, 1.1"
      ];
      description = "Monitors to use";
    };

    workspaces = mkOption {
      type = types.listOf types.str;
      default = [
        "1, monitor:eDP-1, persistent:true, default:true"
        "2, monitor:eDP-1, persistent:true, default:false"
        "3, monitor:eDP-1, persistent:true, default:false"
        "4, monitor:eDP-1, persistent:true, default:false"
        "5, monitor:eDP-1, persistent:true, default:false"
        "6, monitor:eDP-1, persistent:true, default:false"
      ];
      description = "Workspaces to use";
    };

    defaultWorkspaces = {
      browser = mkOption {
        type = types.int;
        default = 1;
        description = "default browser workspace";
      };
      gaming = mkOption {
        type = types.int;
        default = 1;
        description = "default gaming workspace";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      monitor = cfg.monitors;
      workspace = cfg.workspaces;

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 8;
        gaps_out = 12;
        border_size = 3;
        # "col.active_border" = "$mauve";
        # "col.inactive_border" = "$surface0";

        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        rounding = 8;

        active_opacity = 1.0;
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 12;
          render_power = 3;
          # color = "$crust";
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 1;
          vibrancy = 0.1696;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "myBezier, 0.10, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 5, myBezier, popin"
          "windowsOut, 1, 5, myBezier, popin"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      windowrulev2 = [
        "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = -1;
      };

      "$resizeIncrement" = 25;

      bind = [
        # "SUPER, M, exit"

        "ALT, F4, killactive"
        "SUPER, C, killactive"

        "SUPER, V, togglefloating"
        "SUPER, P, pseudo"
        "SUPER, J, togglesplit"
        "SUPER, F, fullscreen"

        # move focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # move windows around inside a workspace
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"

        # scroll through existing workspaces
        "SUPER CTRL, right, workspace, e+1"
        "SUPER CTRL, left, workspace, e-1"

        # navigate workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # move window to workspace
        "SUPER CTRL SHIFT, right, movetoworkspace, e+1"
        "SUPER CTRL SHIFT, left, movetoworkspace, e-1"
        "SUPER CTRL SHIFT, 1, movetoworkspace, 1"
        "SUPER CTRL SHIFT, 2, movetoworkspace, 2"
        "SUPER CTRL SHIFT, 3, movetoworkspace, 3"
        "SUPER CTRL SHIFT, 4, movetoworkspace, 4"
        "SUPER CTRL SHIFT, 5, movetoworkspace, 5"
        "SUPER CTRL SHIFT, 6, movetoworkspace, 6"
        "SUPER CTRL SHIFT, 7, movetoworkspace, 7"
        "SUPER CTRL SHIFT, 8, movetoworkspace, 8"
        "SUPER CTRL SHIFT, 9, movetoworkspace, 9"
        "SUPER CTRL SHIFT, 0, movetoworkspace, 10"
      ];

      binde = [
        # resize windows
        "SUPER ALT, right, resizeactive, $resizeIncrement 0"
        "SUPER ALT, left, resizeactive, -$resizeIncrement 0"
        "SUPER ALT, up, resizeactive, 0 -$resizeIncrement"
        "SUPER ALT, down, resizeactive, 0 $resizeIncrement"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
