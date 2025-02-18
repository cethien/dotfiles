{ lib, config, ... }:
let
  inherit (lib) mkIf mkForce mkOption;
  cfg = config.deeznuts.desktop.hyprland.hyprlock;
  enable = config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.desktop.hyprland.hyprlock = {
    monitor = mkOption {
      type = lib.types.str;
      default = "eDP-1";
      description = "Monitor to use for the hyprlock background";
    };
  };

  config = mkIf enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          grace = 0;
          hide_cursor = true;
          no_fade_in = true;
        };

        # background = [
        #   {
        #     monitor = cfg.monitor;
        #     path = "/home/cethien/Pictures/wallpapers/drippy-smiley.jpg";
        #     blur_passes = 2;
        #     blur_size = 4;
        #   }
        #   {
        #     monitor = "HDMI-A-1";
        #     color = "#111322";
        #   }
        # ];

        input-field = mkForce [
          {
            monitor = cfg.monitor;
            fade_on_empty = false;
            font_family = "MesloLGM Nerd Font";
            font_color = "rgb(205, 214, 244)";
            inner_color = "rgb(24, 24, 37)";
            outer_color = "rgb(17, 17, 27)";
            placeholder_color = "rgb(166, 173, 200)";
            placeholder_text = "Enter Password";
          }
        ];

        label = [
          {
            monitor = cfg.monitor;
            text = "cmd[update:1000] echo \"$TIME\"";
            color = "rgb(205, 214, 244)";
            font_size = 55;
            font_family = "MesloLGM Nerd Font";
            position = "-50, 50";
            halign = "right";
            valign = "bottom";
            shadow_passes = 5;
            shadow_size = 10;
          }
          {
            monitor = cfg.monitor;
            text = "$USER";
            color = "rgb(205, 214, 244)";
            font_size = 35;
            font_family = "MesloLGM Nerd Font Mono";
            position = "0, 100";
            halign = "center";
            valign = "center";
            shadow_passes = 5;
            shadow_size = 10;
          }
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

