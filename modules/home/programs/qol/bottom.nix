{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.deeznuts.programs.qol.bottom;
in {
  options.deeznuts.programs.qol.bottom = {
    hyprland.workspace = mkOption {
      type = types.int;
      default = 8;
      description = "default hyprland workspace";
    };
  };

  config = mkIf config.programs.bottom.enable {
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap.btm = "";
    home.packages = [
      (pkgs.writeShellScriptBin "hypr_btm" ''
        #!/usr/bin/env bash
        hyprctl clients | grep -q 'class:.*btm' &&
          hyprctl dispatch focuswindow class:btm ||
          kitty --class btm -e btm &
      '')
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, p, exec, hypr_btm"
      ];

      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:btm"
      ];
    };

    home.shellAliases = {
      top = "btm --basic";
      htop = "btm --basic";
    };

    programs.bottom = {
      settings = {
        flags = {
          temperature_type = "c"; # Celsius
          tree = true;
          cpu_as_percentage = true;
          cpu_left_legend = true;
          disable_advanced_kill = true;
          default_widget_type = "proc";
        };

        row = [
          {
            child = [
              {type = "cpu";}
              {
                child = [
                  {
                    type = "mem";
                    default_mode = "table";
                  }
                  {
                    type = "net";
                    default_mode = "table";
                  }
                ];
              }
            ];
          }
          {
            child = [
              {type = "proc";}
            ];
          }
          {
            child = [
              {type = "disk";}
              {type = "temperature";}
            ];
          }
        ];
      };
    };
  };
}
