{
  general = {
    gaps_in = 8;
    gaps_out = 12;
    border_size = 3;
    "col.active_border" = "$mauve";
    "col.inactive_border" = "$surface0";

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
      color = "$crust";
    };

    blur = {
      enabled = true;
      size = 3;
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
  };

  bind = [
    "SUPER, M, exit"

    "ALT, F4, killactive"
    "SUPER, C, killactive"

    "SUPER, V, togglefloating"
    "SUPER, P, pseudo"
    "SUPER, J, togglesplit"

    "SUPER, left, movefocus, l"
    "SUPER, right, movefocus, r"
    "SUPER, up, movefocus, u"
    "SUPER, down, movefocus, d"
  ];

  bindm = [
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
  ];
}
