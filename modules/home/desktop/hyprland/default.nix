{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault mkOption types;
in {
  imports = [
    ./rofi.nix
    ./common-gui.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprshot.nix
    ./mako.nix
  ];

  options.wayland.windowManager.hyprland = {
    autostart = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    defaultWorkspaces = {
      browser = mkOption {
        type = types.int;
        default = 1;
        description = "default browser workspace";
      };
      gaming = mkOption {
        type = types.int;
        default = 3;
        description = "default gaming workspace";
      };
    };
  };

  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = with pkgs; [
      playerctl
      brightnessctl
      wl-clipboard
    ];
    services.hyprpaper.enable = true;
    services.mako.enable = true;
    programs.rofi.enable = true;

    wayland.windowManager.hyprland.settings = {
      exec-once = ["${pkgs.udiskie}/bin/udiskie"];

      monitor = mkDefault [
        "eDP-1, 1920x1080@60, 0x0, 1"
      ];

      workspace = mkDefault [
        "1, monitor:eDP-1, persistent:true, default:true"
        "2, monitor:eDP-1, persistent:true, default:false"
        "3, monitor:eDP-1, persistent:true, default:false"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 4;
        # "col.active_border" = "";
        # "col.inactive_border" = "";

        layout = "master";
      };

      master = {
        mfact = 0.6;
        orientation = "right";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 1;
      };

      decoration = {
        rounding = 6;

        active_opacity = 1.0;
        inactive_opacity = 0.9;
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
          "deez, 0.10, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 5, deez, slide"
          "border, 1, 3, deez"
          "fade, 1, 3, deez"
          "workspaces, 1, 3, deez"
        ];
      };

      windowrulev2 = [
        "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;

        focus_on_activate = true;
        enable_swallow = true;
      };

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = 2;
      };

      "$resizeIncrement" = 25;

      bind = [
        "SUPER SHIFT, C, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"

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

      bindl = [
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
