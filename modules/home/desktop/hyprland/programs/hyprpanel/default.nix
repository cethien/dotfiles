{ lib
, config
, inputs
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkOption;
  cfg = config.deeznuts.desktop.hyprland.hyprpanel;
  enable = config.deeznuts.desktop.hyprland.enable;

  jsonFormat = pkgs.formats.json { };
in
{
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  options.deeznuts.desktop.hyprland.hyprpanel = {
    layout = mkOption {
      type = jsonFormat.type;
      default = {
        "bar.layouts" = {
          "0" = {
            left = [ "workspaces" "systray" "windowtitle" ];
            middle = [ "media" ];
            right = [ "volume" "bluetooth" "network" "battery" "notifications" "clock" "dashboard" ];
          };
        };
      };
    };
  };

  config = mkIf enable {
    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;

      theme = "tokyo_night";

      layout = cfg.layout;

      settings = {
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

            scrollUp = "playerctl --player=spotify volume 0.05+";
            scrollDown = "playerctl --player=spotify volume 0.05-";
          };

          network.label = false;

          volume.label = false;

          workspaces = {
            showApplicationIcons = true;
            show_icons = true;
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
