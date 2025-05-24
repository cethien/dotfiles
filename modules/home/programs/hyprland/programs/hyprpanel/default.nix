{ lib
, config
, inputs
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.programs.hyprpanel;
  enabled = cfg.enable;

  jsonFormat = pkgs.formats.json { };
in
{
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

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
          "bar.layouts" = {
            "*" = {
              left = [ "workspaces" "systray" ];
              middle = [ "media" ];
              right = [ "volume" ] ++
                (if cfg.layout.bluetooth then [ "bluetooth" ] else [ ]) ++
                [ "network" "notifications" ] ++
                (if cfg.layout.battery then [ "battery" "hypridle" ] else [ ]) ++
                [ "clock" ];
            };
          };
        };
      };
    };
    workspacesNum = mkOption {
      type = types.int;
      default = 5;
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, I, exec, hyprpanel idleInhibit"
      ];
    };


    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;

      settings = {
        theme.name = "one_dark";
        layout = cfg.layout.layout;
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

            # scrollUp = "playerctl --player=spotify volume 0.05+";
            # scrollDown = "playerctl --player=spotify volume 0.05-";
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
            name = "MesloLG Nerd Font";
            size = "16px";
          };

          osd = {
            location = "bottom";
            orientation = "horizontal";
            margins = "0px 0px 2rem 0px";
          };
        };
      };
    };

    home.file.".config/hypr/assets/logo.png".source = ./logo.png;
  };
}
