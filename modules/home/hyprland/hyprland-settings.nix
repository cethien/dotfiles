{pkgs, ...}: {
  xwayland = {
    force_zero_scaling = true;
  };

  general = {
    gaps_in = 2;
    gaps_out = 4;
    border_size = 4;

    layout = "scrolling";
  };

  scrolling = {
    column_width = 0.8;
    focus_fit_method = 0;
  };

  master = {
    mfact = 0.6;
    orientation = "right";
  };

  dwindle = {
    preserve_split = true;
    force_split = 1;
  };

  decoration = {
    rounding = 6;

    active_opacity = 1.0;
    inactive_opacity = 0.975;
    fullscreen_opacity = 1.0;

    shadow = {
      enabled = true;
      range = 12;
      render_power = 3;
      # color = "$crust";
    };

    blur = {
      enabled = true;
      size = 8;
      passes = 3;
      vibrancy = 0.6;
      brightness = 1.0;
      contrast = 1.2;
      new_optimizations = true;
      ignore_opacity = true;
    };
  };

  animations = {
    enabled = true;

    bezier = [
      "deez, 0.22, 0.85, 0, 1.03"
    ];

    animation = [
      "windows, 1, 5, deez, slide"
      "border, 1, 3, deez"
      "fade, 1, 3, deez"
      "workspaces, 1, 3, deez"
      "specialWorkspace, 1, 3, deez, slidevert"
    ];
  };

  windowrule = [
    "suppress_event maximize, match:class .*"
    "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
  ];

  cursor = {
    inactive_timeout = 5;
    persistent_warps = true;
  };

  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    middle_click_paste = false;
    focus_on_activate = true;
    enable_swallow = true;
  };

  ecosystem.no_donation_nag = true;

  input = {
    kb_layout = "de";
    kb_variant = "nodeadkeys";
    follow_mouse = 2;
  };

  bind = let
    toggleLayout = pkgs.writeShellScriptBin "hyprland-toggle-layout" ''
      set -e
      if hyprctl getoption general:layout | grep -q "master"; then
          hyprctl keyword general:layout scrolling
      else
          hyprctl keyword general:layout master
      fi
    '';
  in [
    "ALT, F4, killactive"
    "SUPER, C, killactive"

    "SUPER, V, pseudo"
    "SUPER, J, exec, ${toggleLayout}/bin/hyprland-toggle-layout"
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

    "SUPER SHIFT, C, exec, hyprpicker -a"
  ];

  binde = let
    ri = "25";
  in [
    "SUPER ALT, right, resizeactive, ${ri} 0"
    "SUPER ALT, left, resizeactive, -${ri} 0"
    "SUPER ALT, up, resizeactive, 0 -${ri}"
    "SUPER ALT, down, resizeactive, 0 ${ri}"
  ];

  bindm = [
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];

  bindl = [
    ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
    ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
  ];
}
