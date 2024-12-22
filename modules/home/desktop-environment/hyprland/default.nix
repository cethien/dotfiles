{ lib, config, pkgs, ... }:

{
  options.desktop-environment.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.desktop-environment.hyprland.enable {
    services.mako.enable = true;
    services.playerctld.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      plugins = with pkgs.hyprlandPlugins; [
        hyprspace
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
          "waybar"
          "firefox & spotify & discordcanary"
          "steam"
        ];

        # See https://wiki.hyprland.org/Configuring/Keywords/
        "$terminal" = "kitty";
        "$fileManager" = "kitty yy";
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
          follow_mouse = -1;
        };

        # https://wiki.hyprland.org/Configuring/Keywords/
        "$mainMod" = "SUPER"; # windows key

        # https://wiki.hyprland.org/Configuring/Binds/
        bind = [
          "$mainMod, M, exit"

          "ALT, F4, killactive"
          "$mainMod, C, killactive"

          "$mainMod, R, exec, $menu"
          "$mainMod, T, exec, $terminal"
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
          "$mainMod CTRL, left, workspace, e-1"
          "$mainMod CTRL, right, workspace, e-2"

          "$mainMod, TAB, overview:toggle"
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

    # programs.hyprlock.enable = true;
    # services.hypridle.enable = true;

    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg" ];

        wallpaper = [
          ",/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg"
        ];
      };
    };

    programs.waybar = {
      enable = true;

      settings.mainBar = {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 34;
        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "memory"
          "network"
          "wireplumber"
          "battery"
          "custom/power"
        ];
        "wlr/taskbar" = {
          "format" = "{icon}";
          "on-click" = "activate";
          "on-click-right" = "fullscreen";
          "icon-theme" = "WhiteSur";
          "icon-size" = 25;
          "tooltip-format" = "{title}";
        };
        "hyprland/workspaces" = {
          "on-click" = "activate";
          "format" = "{icon}";
          "format-icons" = {
            "default" = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "active" = "󱓻";
            "urgent" = "󱓻";
          };
          "persistent_workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        "memory" = {
          "interval" = 5;
          "format" = "󰍛 {}%";
          "max-length" = 10;
        };
        "tray" = {
          "spacing" = 10;
        };
        "clock" = {
          "tooltip-format" = "{calendar}";
          "format-alt" = "  {=%a %d %b %Y}";
          "format" = "  {=%I=%M %p}";
        };
        "network" = {
          "format-wifi" = "{icon}";
          "format-icons" = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          "format-ethernet" = "󰀂";
          "format-alt" = "󱛇";
          "format-disconnected" = "󰖪";
          "tooltip-format-wifi" = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-ethernet" = "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-disconnected" = "Disconnected";
          "on-click" = "~/.config/rofi/wifi/wifi.sh &";
          "on-click-right" = "~/.config/rofi/wifi/wifinew.sh &";
          "interval" = 5;
          "nospacing" = 1;
        };
        "wireplumber" = {
          "format" = "{icon}";
          "format-bluetooth" = "󰂰";
          "nospacing" = 1;
          "tooltip-format" = "Volume = {volume}%";
          "format-muted" = "󰝟";
          "format-icons" = {
            "headphone" = "";
            "default" = [ "󰖀" "󰕾" "" ];
          };
          "on-click" = "pamixer -t";
          "scroll-step" = 1;
        };
        "custom/logo" = {
          "format" = "  ";
          "tooltip" = false;
          "on-click" = "~/.config/rofi/launchers/misc/launcher.sh &";
        };
        "battery" = {
          "format" = "{capacity}% {icon}";
          "format-icons" = {
            "charging" = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            "default" = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          "format-full" = "Charged ";
          "interval" = 5;
          "states" = {
            "warning" = 20;
            "critical" = 10;
          };
          "tooltip" = false;
        };
        "custom/power" = {
          "format" = "󰤆";
          "tooltip" = false;
          "on-click" = "~/.config/rofi/powermenu/type-2/powermenu.sh &";
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: JetBrainsMono Nerd Font;
          font-size: 13px;
        }

        window#waybar {
          background-color: #181825;
          transition-property: background-color;
          transition-duration: 0.5s;
        }

        window#waybar.hidden {
          opacity: 0.5;
        }

        #workspaces {
          background-color: transparent;
        }

        #workspaces button {
          all: initial;
          /* Remove GTK theme values (waybar #1351) */
          min-width: 0;
          /* Fix weird spacing in materia (waybar #450) */
          box-shadow: inset 0 -3px transparent;
          /* Use box-shadow instead of border so the text isn't offset */
          padding: 6px 18px;
          margin: 6px 3px;
          border-radius: 4px;
          background-color: #1e1e2e;
          color: #cdd6f4;
        }

        #workspaces button.active {
          color: #1e1e2e;
          background-color: #cdd6f4;
        }

        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          color: #1e1e2e;
          background-color: #cdd6f4;
        }

        #workspaces button.urgent {
          background-color: #f38ba8;
        }

        #memory,
        #custom-power,
        #battery,
        #backlight,
        #wireplumber,
        #network,
        #clock,
        #tray {
          border-radius: 4px;
          margin: 6px 3px;
          padding: 6px 12px;
          background-color: #1e1e2e;
          color: #181825;
        }

        #custom-power {
          margin-right: 6px;
        }

        #custom-logo {
          padding-right: 7px;
          padding-left: 7px;
          margin-left: 5px;
          font-size: 15px;
          border-radius: 8px 0px 0px 8px;
          color: #1793d1;
        }

        #memory {
          background-color: #fab387;
        }

        #battery {
          background-color: #f38ba8;
        }

        #battery.warning,
        #battery.critical,
        #battery.urgent {
          background-color: #ff0000;
          color: #FFFF00;
        }

        #battery.charging {
          background-color: #a6e3a1;
          color: #181825;
        }

        #backlight {
          background-color: #fab387;
        }

        #wireplumber {
          background-color: #f9e2af;
        }

        #network {
          background-color: #94e2d5;
          padding-right: 17px;
        }

        #clock {
          font-family: JetBrainsMono Nerd Font;
          background-color: #cba6f7;
        }

        #custom-power {
          background-color: #f2cdcd;
        }


        tooltip {
          border-radius: 8px;
          padding: 15px;
          background-color: #131822;
        }

        tooltip label {
          padding: 5px;
          background-color: #131822;
        }
      '';
    };

    programs.rofi = {
      enable = true;
    };
  };
}
