{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.hyprland.hyprlock;
  enable = config.deeznuts.programs.hyprland.enable;
in {
  options.deeznuts.programs.hyprland.hyprlock = {
    monitor = mkOption {
      type = types.str;
      default = "eDP-1";
      description = "Monitor to use for the hyprlock background";
    };
    showBattery = mkOption {
      type = types.bool;
      default = true;
      description = "show battery label";
    };
  };

  config = mkIf enable {
    stylix.targets.hyprlock.enable = false;
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        image = [
          {
            monitor = cfg.monitor;
            path = "${config.home.homeDirectory}/Pictures/smiley.png";
            halign = "center";
            valign = "center";
            position = "0, 100";
            size = 200;
            rounding = 0;
            border_size = 0;
          }
        ];

        input-field = mkForce [
          {
            monitor = cfg.monitor;
            fade_on_empty = false;
            font_family = config.stylix.fonts.monospace.name;

            # The main color of the "Enter Password" text when nothing is typed
            placeholder_color = "rgba(110, 106, 134, 1.0)"; # base04 - Muted Grey, soft hint

            # Color of the text you type (Inner Font)
            bar_text_color = "rgba(224, 222, 244, 1.0)"; # base05 - Pale Lavender White, clear and readable

            # Color of the background of the input bar
            bar_color = "rgba(31, 29, 46, 0.6)"; # base01 - Darker Plum/Gray, subtle transparency

            # Ring colors (Outer Ring)
            fail_color = "rgba(231, 130, 132, 1.0)"; # base0E - Red Accent for errors
            ring_color = "rgba(38, 35, 53, 1.0)"; # base02 - Mid-Dark Plum/Gray, default ring (subtle)
            ring_color_error = "rgba(231, 130, 132, 1.0)"; # base0E - Red for error ring
            ring_color_clear = "rgba(49, 116, 143, 1.0)"; # base0B - Iris/Teal, calming clear input
            ring_color_caps = "rgba(246, 193, 119, 1.0)"; # base09 - Gold/Orange for Caps Lock (warning)
            ring_color_vkey = "rgba(196, 167, 231, 1.0)"; # base0D - Lilac/Lavender for virtual keyboard
            ring_color_verify = "rgba(49, 116, 143, 1.0)"; # base0B - Iris/Teal, calming verify

            placeholder_text = "enter password";

            halign = "center";
            valign = "center";
            position = "0, -100";
          }
        ];

        label = mkMerge [
          [
            {
              monitor = cfg.monitor;
              color = "rgba(224, 222, 244, 1.0)"; # base05 - Pale Lavender White, main text color
              font_family = config.stylix.fonts.sansSerif.name;
              font_size = "95";
              halign = "center";
              valign = "top";
              position = "0, -75";
              text = "$TIME";
            }

            {
              monitor = cfg.monitor;
              color = "rgba(224, 222, 244, 1.0)"; # base05 - Pale Lavender White, main text color
              font_family = config.stylix.fonts.sansSerif.name;
              font_size = "22";
              halign = "center";
              valign = "top";
              position = "0, -35";
              text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
            }
          ]
          (mkIf cfg.showBattery [
            {
              monitor = cfg.monitor;
              color = "rgba(235, 111, 146, 1.0)"; # base08 - Rosewater/Pink Accent for a cozy pop!
              font_family = config.stylix.fonts.sansSerif.name;
              font_size = "24";
              halign = "center";
              valign = "bottom";
              position = "0, 60";
              text = ''cmd[update:1000] hyprlock-batterystatus'';
            }
          ])
        ];
      };
    };

    home.packages = [
      (pkgs.writeShellScriptBin "hyprlock-batterystatus" (builtins.readFile ./hyprlock-batterystatus.sh))
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, L, exec, hyprlock"
      ];
    };
  };
}
