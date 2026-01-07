{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.hyprlock;

  fonts = config.stylix.fonts;
  colors = {
    base01 = "rgba(31, 29, 46, 0.6)"; # base01 - Darker Plum/Gray, subtle transparency
    base02 = "rgba(38, 35, 53, 1.0)"; # base02 - Mid-Dark Plum/Gray, default ring (subtle)
    base04 = "rgba(110, 106, 134, 1.0)"; # base04 - Muted Grey, soft hint
    base05 = "rgba(224, 222, 244, 1.0)"; # base05 - Pale Lavender White, clear and readable
    base08 = "rgba(235, 111, 146, 1.0)"; # base08 - Rosewater/Pink Accent for a cozy pop!
    base09 = "rgba(246, 193, 119, 1.0)"; # base09 - Gold/Orange for Caps Lock (warning)
    base0B = "rgba(49, 116, 143, 1.0)"; # base0B - Iris/Teal, calming clear input
    base0D = "rgba(196, 167, 231, 1.0)"; # base0D - Lilac/Lavender for virtual keyboard
    base0E = "rgba(231, 130, 132, 1.0)"; # base0E - Red Accent for errors
  };
in {
  options.programs.hyprlock.monitor = lib.mkOption {
    type = lib.types.str;
    default = "eDP-1";
  };

  config = mkIf config.wayland.windowManager.hyprland.enable {
    stylix.targets.hyprlock.enable = false;
    programs.hyprlock = {
      enable = true;

      settings = let
        shadows = {
          shadow_passes = 4;
          shadow_size = 6;
          shadow_color = "rgb(0,0,0)";
          shadow_boost = 1.2;
        };
      in {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 4;
            blur_size = 12;
          }
        ];

        input-field = lib.mkForce [
          (shadows
            // {
              monitor = cfg.monitor;
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

              placeholder_text = "pwd";

              halign = "center";
              valign = "center";
              position = "0, 0";
            })
        ];

        label = lib.mkMerge [
          [
            (shadows
              // {
                monitor = cfg.monitor;
                color = colors.base05;
                font_family = fonts.sansSerif.name;
                font_size = "95";
                halign = "center";
                valign = "center";
                position = "0, 325";
                text = "$TIME";
              })
            (shadows
              // {
                monitor = cfg.monitor;
                color = colors.base05;
                font_family = fonts.sansSerif.name;
                font_size = "22";
                halign = "center";
                valign = "center";
                position = "0, 200";
                text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
              })
            (shadows
              // {
                monitor = cfg.monitor;
                color = colors.base05;
                font_family = fonts.sansSerif.name;
                font_size = "22";
                halign = "center";
                valign = "center";
                position = "0, -255";
                text = ''cmd[update:1000] ${pkgs.writeShellScriptBin "hyprlock-batterystatus" (builtins.readFile ./hyprlock-batterystatus.sh)}/bin/hyprlock-batterystatus'';
              })
          ]
        ];
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, L, exec, hyprlock"
      ];
    };
  };
}
