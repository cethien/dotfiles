{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.hyprlock;

  monitor = cfg.monitor;
  fonts = config.stylix.fonts;
  colors = let
    c = config.lib.stylix.colors;
    o = toString config.stylix.opacity.terminal;
  in {
    base01 = "rgba(${c.base01-rgb-r}, ${c.base01-rgb-g}, ${c.base01-rgb-b}, ${o})";
    base02 = "rgba(${c.base02-rgb-r}, ${c.base02-rgb-g}, ${c.base02-rgb-b}, ${o})";
    base04 = "rgba(${c.base04-rgb-r}, ${c.base04-rgb-g}, ${c.base04-rgb-b}, ${o})";
    base05 = "rgba(${c.base05-rgb-r}, ${c.base05-rgb-g}, ${c.base05-rgb-b}, ${o})";
    base08 = "rgba(${c.base08-rgb-r}, ${c.base08-rgb-g}, ${c.base08-rgb-b}, ${o})";
    base09 = "rgba(${c.base09-rgb-r}, ${c.base09-rgb-g}, ${c.base09-rgb-b}, ${o})";
    base0B = "rgba(${c.base0B-rgb-r}, ${c.base0B-rgb-g}, ${c.base0B-rgb-b}, ${o})";
    base0D = "rgba(${c.base0D-rgb-r}, ${c.base0D-rgb-g}, ${c.base0D-rgb-b}, ${o})";
    base0E = "rgba(${c.base0E-rgb-r}, ${c.base0E-rgb-g}, ${c.base0E-rgb-b}, ${o})";
  };

  withDefaults = attrs:
    {
      inherit monitor halign valign;
      shadow_passes = 4;
      shadow_size = 6;
      shadow_color = "rgb(0,0,0)";
      shadow_boost = 1.2;
    }
    // attrs;

  halign = "center";
  valign = "center";

  statusScript = "${pkgs.writeShellScriptBin "hyprlock-status" (builtins.readFile ./hyprlock-status.sh)}/bin/hyprlock-status";
  quotesScript = "${pkgs.writeShellScriptBin "hyprlock-quotes" (builtins.readFile ./hyprlock-quotes.sh)}/bin/hyprlock-quotes";
in {
  options.programs.hyprlock.monitor = lib.mkOption {
    type = lib.types.str;
    default = "eDP-1";
  };

  config = mkIf cfg.enable {
    stylix.targets.hyprlock.enable = false;

    programs.hyprlock = {
      package = pkgs-unstable.hyprlock;
      settings = {
        auth.fingerprint = {
          enabled = true;
          ready_message = "pwd or fprint";
          present_message = "scanning...";
        };

        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = true;
          ignore_empty_input = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 4;
            blur_size = 12;
          }
        ];

        input-field = lib.mkForce [
          (withDefaults {
            fade_on_empty = false;
            font_family = fonts.monospace.name;

            placeholder_color = colors.base04;
            bar_text_color = colors.base01;
            bar_color = colors.base01;
            fail_color = colors.base0E;

            ring_color = colors.base02;

            ring_color_error = colors.base0E;
            ring_color_clear = colors.base0B;
            ring_color_caps = colors.base09;
            ring_color_vkey = colors.base0D;
            ring_color_verify = colors.base0B;

            placeholder_text = "";
            fail_text = "whoops! try again";

            position = "0, 0";
          })
        ];

        label = let
          mkLabel = attrs:
            withDefaults ({
                font_family = fonts.sansSerif.name;
                color = colors.base05;
              }
              // attrs);
        in [
          (mkLabel {
            font_size = "95";
            position = "0, 325";
            text = "$TIME";
          })
          (mkLabel {
            font_size = "22";
            position = "0, 200";
            text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
          })
          (mkLabel {
            font_size = "22";
            position = "0, -255";
            text = "cmd[update:1000] ${statusScript}";
          })
          (mkLabel {
            color = colors.base04;
            font_size = "14";
            text_align = "center";
            position = "0, -150";
            text = "cmd[update:0] ${quotesScript}";
          })
        ];
      };
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-lock" = ''
      hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
    '';
  };
}
