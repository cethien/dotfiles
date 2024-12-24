{ lib, config, ... }:

{
  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    # https://wiki.hyprland.org/Configuring/Binds/
    wayland.windowManager.hyprland.settings = {

      # https://wiki.hyprland.org/Configuring/Keywords/
      "$mainMod" = "SUPER"; # windows key

      bind = [
        "$mainMod, M, exit"

        "ALT, F4, killactive"
        "$mainMod, C, killactive"

        "$mainMod, R, exec, $menu"
        "$mainMod, Q, exec, $terminal"
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
    };
  };
}
