{ lib, config, inputs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  config = mkIf cfg.enable {
    programs.hyprpanel = {
      enable = true;
      overlay.enable = true;
      systemd.enable = true;
      hyprland.enable = true;
      overwrite.enable = true;

      theme = "catppuccin_mocha";

      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "workspaces" "windowtitle" ];
            middle = [ "clock" ];
            right = [ "media" ];
          };
          "1" = {
            left = [ "workspaces" "windowtitle" ];
            middle = [ "" ];
            right = [ "systray" "volume" "bluetooth" "network" "clock" "notifications" "dashboard" ];
          };
        };
      };

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
            truncation = false;

            scrollUp = "playerctl --player=spotify volume 0.05+";
            scrollDown = "playerctl --player=spotify volume 0.05-";
          };

          network.label = false;

          volume.label = false;

          workspaces.showApplicationIcons = true;
          workspaces.show_icons = true;
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
            stats.enable_gpu = true;

            shortcuts.enabled = false;
          };
        };

        theme = {
          bar.transparent = true;

          font = {
            name = "MesloLGL Nerd Font";
            size = "16px";
          };

          osd = {
            location = "bottom";
            orientation = "horizontal";
          };
        };
      };
    };
  };
}
