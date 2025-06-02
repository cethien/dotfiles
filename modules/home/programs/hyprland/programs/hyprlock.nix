{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkForce mkOption;
  cfg = config.deeznuts.programs.hyprland.hyprlock;
  enable = config.deeznuts.programs.hyprland.enable;
in {
  options.deeznuts.programs.hyprland.hyprlock = {
    monitor = mkOption {
      type = lib.types.str;
      default = "eDP-1";
      description = "Monitor to use for the hyprlock background";
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
            path = "${config.home.homeDirectory}/Pictures/logo.png";
            halign = "center";
            valign = "center";
            position = "0, 50";
          }
        ];

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

            halign = "center";
            valign = "center";
            position = "0, -100";
          }
        ];

        label = [
          {
            monitor = cfg.monitor;
            color = "rgba(242, 243, 244, 0.75)";
            font_family = "JetBrains Mono";
            font_size = "95";
            halign = "center";
            position = "0, 200";
            text = "$TIME";
            valign = "center";
          }

          {
            monitor = cfg.monitor;
            color = "rgba(242, 243, 244, 0.75)";
            font_family = "JetBrains Mono";
            font_size = "22";
            halign = "center";
            position = "0, 300";
            text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
            valign = "center";
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
