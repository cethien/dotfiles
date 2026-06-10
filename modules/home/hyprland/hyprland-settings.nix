{hlLib, ...}: let
  inherit (hlLib) mkWindowRule mkDspBind mkExecBind;
in {
  config = {
    decoration = {
      rounding = 6;

      active_opacity = 1.0;
      inactive_opacity = 0.975;
      fullscreen_opacity = 1.0;

      shadow = {
        range = 12;
        render_power = 3;
      };

      blur = {
        size = 8;
        passes = 3;
        vibrancy = 0.6;
        brightness = 1.0;
        contrast = 1.2;
      };
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

    cursor = {
      inactive_timeout = 5;
      persistent_warps = true;
    };

    xwayland = {
      force_zero_scaling = true;
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
  };

  curve = [
    {
      _args = [
        "deez"
        {
          type = "bezier";
          points = [[0.22 0.85] [0 1.03]];
        }
      ];
    }
  ];
  animation = [
    {
      _args = [
        {
          leaf = "windows";
          enabled = true;
          speed = 5.0;
          bezier = "deez";
          style = "slide";
        }
      ];
    }
    {
      _args = [
        {
          leaf = "border";
          enabled = true;
          speed = 3.0;
          bezier = "deez";
        }
      ];
    }
    {
      _args = [
        {
          leaf = "fade";
          enabled = true;
          speed = 3.0;
          bezier = "deez";
        }
      ];
    }
    {
      _args = [
        {
          leaf = "workspaces";
          enabled = true;
          speed = 2.0;
          bezier = "deez";
        }
      ];
    }
    {
      _args = [
        {
          leaf = "specialWorkspace";
          enabled = true;
          speed = 3.0;
          bezier = "deez";
          style = "slidevert";
        }
      ];
    }
  ];

  window_rule = [
    (mkWindowRule {class = ".*";} {suppress_event = "maximize";})
    (mkWindowRule {float = true;} {
      center = true;
      size = ["(monitor_w*0.7)" "(monitor_h*0.7)"];
    })
    (mkWindowRule {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      } {
        no_focus = true;
      })
  ];

  bind = let
    ri = "25";
  in
    [
      # Misc Apps
      (mkExecBind "SUPER + SHIFT + C" "hyprpicker -a" {})

      # Native Layout Toggler
      (mkDspBind "SUPER + J" ''
        function()
          local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
          if ws then
            if ws.tiled_layout == "master" then
              hl.dispatch(hl.dsp.keyword("general:layout", "scrolling"))
            else
              hl.dispatch(hl.dsp.keyword("general:layout", "master"))
            end
          end
        end
      '' {})

      # Core Window Management
      (mkDspBind "ALT + F4" "hl.dsp.window.close()" {})
      (mkDspBind "SUPER + C" "hl.dsp.window.close()" {})
      (mkDspBind "SUPER + V" "hl.dsp.window.float({ action = 'toggle' })" {})
      (mkDspBind "SUPER + F" "hl.dsp.window.fullscreen({ action = 'toggle' })" {})

      # Move Focus
      (mkDspBind "SUPER + left" "hl.dsp.focus({direction = 'left'})" {})
      (mkDspBind "SUPER + right" "hl.dsp.focus({direction = 'right'})" {})
      (mkDspBind "SUPER + up" "hl.dsp.focus({direction = 'up'})" {})
      (mkDspBind "SUPER + down" "hl.dsp.focus({direction = 'down'})" {})

      # Scroll through Workspaces
      (mkDspBind "SUPER + CTRL + right" "hl.dsp.focus({workspace = 'e+1'})" {})
      (mkDspBind "SUPER + CTRL + left" "hl.dsp.focus({workspace = 'e-1'})" {})

      # Move Windows
      (mkDspBind "SUPER + SHIFT + left" "hl.dsp.window.move({ direction = 'left' })" {})
      (mkDspBind "SUPER + SHIFT + right" "hl.dsp.window.move({ direction = 'right' })" {})
      (mkDspBind "SUPER + SHIFT + up" "hl.dsp.window.move({ direction = 'up' })" {})
      (mkDspBind "SUPER + SHIFT + down" "hl.dsp.window.move({ direction = 'down' })" {})

      (mkDspBind "SUPER + CTRL + SHIFT + right" "hl.dsp.window.move({workspace = 'e+1'})" {})
      (mkDspBind "SUPER + CTRL + SHIFT + left" "hl.dsp.window.move({workspace = 'e-1'})" {})

      # Resize
      (mkDspBind "SUPER + ALT + right" "hl.dsp.window.resize({ x = ${ri}, y = 0, relative = true })" {repeating = true;})
      (mkDspBind "SUPER + ALT + left" "hl.dsp.window.resize({ x = -${ri}, y = 0, relative = true })" {repeating = true;})
      (mkDspBind "SUPER + ALT + up" "hl.dsp.window.resize({ x = 0, y = -${ri}, relative = true })" {repeating = true;})
      (mkDspBind "SUPER + ALT + down" "hl.dsp.window.resize({ x = 0, y = ${ri}, relative = true })" {repeating = true;})

      # Mouse Keybinds
      (mkDspBind "SUPER + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
      (mkDspBind "SUPER + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

      # Locked/Media Keybinds
      (mkExecBind "XF86MonBrightnessUp" "brightnessctl s 5%+" {locked = true;})
      (mkExecBind "XF86MonBrightnessDown" "brightnessctl s 5%-" {locked = true;})
    ]
    ++ (map (
      num: let
        target =
          if num == 0
          then 10
          else num;
        numStr = toString num;
      in
        mkDspBind "SUPER + ${numStr}" "hl.dsp.focus({ workspace = ${toString target} })" {}
    ) [1 2 3 4 5 6 7 8 9 0])
    ++ (map (
      num: let
        target =
          if num == 0
          then 10
          else num;
        numStr = toString num;
      in
        mkDspBind "SUPER + CTRL + SHIFT + ${numStr}" "hl.dsp.window.move({ workspace = ${toString target} })" {}
    ) [1 2 3 4 5 6 7 8 9 0]);
}
