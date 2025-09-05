{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.programs.hyprpanel;
  jsonFormat = pkgs.formats.json {};
in {
  options.deeznuts.programs.hyprpanel = {
    enable = mkEnableOption "hyprpanel";
    layout = {
      battery = mkOption {
        type = types.bool;
        default = true;
        description = "Show battery percentage in the layout";
      };
      bluetooth = mkOption {
        type = types.bool;
        default = true;
        description = "Show bluetooth in the layout";
      };
      layout = mkOption {
        type = jsonFormat.type;
        default = {
          "*" = {
            left = ["workspaces" "systray"];
            middle = ["media"];
            right =
              ["ram" "cpu"]
              ++ (
                if cfg.layout.bluetooth
                then ["bluetooth"]
                else []
              )
              ++ ["network" "volume" "notifications"]
              ++ (
                if cfg.layout.battery
                then ["hypridle" "battery"]
                else []
              )
              ++ ["clock"];
          };
        };
      };
    };
    workspacesNum = mkOption {
      type = types.int;
      default = 5;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, I, exec, hyprpanel idleInhibit"
      ];
    };

    programs.hyprpanel = {
      enable = true;
      settings = {
        bar.layouts = cfg.layout.layout;
        scalingPriority = "hyprland";
        bar = {
          launcher.autoDetectIcon = true;

          bluetooth.label = false;

          clock = {
            format = "%H:%M";
            showIcon = false;
          };

          media = {
            show_active_only = true;
            truncation = true;
            truncation_size = 50;
          };

          network.label = false;

          volume.label = false;

          workspaces = {
            workspaces = cfg.workspacesNum;
            showApplicationIcons = true;
          };
        };

        menus = {
          clock = {
            time = {
              military = true;
              hideSeconds = false;
            };
            weather.enabled = false;
          };

          dashboard = {
            directories.enabled = false;
            shortcuts.enabled = false;
            stats.enable_gpu = true;
            powermenu.avatar.image = "~/.config/hypr/assets/logo.png";
          };
        };

        theme = {
          # name = "one_dark";

          bar = {
            transparent = true;
            outer_spacing = "0.425em";
            border_radius = "8px";
            dropdownGap = "3.8rem";

            buttons = {
              clock.spacing = "0em";
            };
          };

          font = {
            name = config.stylix.fonts.sansSerif.name;
            size = "1rem";
          };

          osd = {
            location = "bottom";
            orientation = "horizontal";
            margins = "0px 0px 2rem 0px";
          };
        };
      };
    };
  };
}
