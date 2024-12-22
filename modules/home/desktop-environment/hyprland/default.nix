{ lib, config, pkgs, ... }:

{
  options.desktop-environment.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.desktop-environment.hyprland.enable {
    services.mako.enable = true;
    services.playerctld.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      plugins = with pkgs.hyprlandPlugins; [
        hyprexpo
      ];

      # https://wiki.hyprland.org/Configuring/
      settings = {
        # See https://wiki.hyprland.org/Configuring/Monitors/
        "monitor" = [
          "DP-1, 2560x1440@240, 0x0, 1"
          "HDMI-A-1, 1920x1080@100, 0x1440, 1"
        ];

        # Autostart
        exec-once = [
          # "hyprpaper & waybar & mako"
          "firefox"
          "spotify"
        ];

        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$terminal" = "kitty";
        "$fileManager" = "kitty yazi";
        "$menu" = "rofi -show drun";

        # See https://wiki.hyprland.org/Configuring/Environment-variables/
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ];

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          resize_on_border = true;

          # https://wiki.hyprland.org/Configuring/Tearing/
          allow_tearing = false;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 8;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # https://wiki.hyprland.org/Configuring/Master-Layout/
        master = {
          new_status = "master";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";
          follow_mouse = 1;
        };

        # https://wiki.hyprland.org/Configuring/Keywords/
        "$mainMod" = "SUPER"; # windows key

        # https://wiki.hyprland.org/Configuring/Binds/
        bind = [
          "$mainMod, M, exit"

          "ALT, F4, killactive"
          "$mainMod, C, killactive"

          "$mainMod, T, exec, $terminal"
          "$mainMod, R, exec, $menu"
          "$mainMod, E, exec, $fileManager"

          "$mainMod, V, togglefloating"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # scratchpad workspace
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          "$mainMod, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          "$mainMod, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          "$mainMod, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "$mainMod, XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          "$mainMod, XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          "$mainMod, XF86MonBrightnessDown, exec, brightnessctl s 10%-"

          "$mainMod, XF86AudioNext, exec, playerctl next"
          "$mainMod, XF86AudioPause, exec, playerctl play-pause"
          "$mainMod, XF86AudioPlay, exec, playerctl play-pause"
          "$mainMod, XF86AudioPrev, exec, playerctl previous"
        ];

        # https://wiki.hyprland.org/Configuring/Window-Rules/
        # https://wiki.hyprland.org/Configuring/Workspace-Rules/
        windowrulev2 = [
          "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
        ];
      };
    };

    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "~/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg" ];

        wallpaper = [
          ",~/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg"
        ];
      };
    };

    programs.waybar = {
      enable = true;
    };

    programs.rofi = {
      enable = true;
    };
  };
}
