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
    home.packages = [
      (pkgs.writeShellScriptBin "hypr_btm" (builtins.readFile ./hyprland_btm.sh))
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        # "SUPER SHIFT, p, exec, $terminal --class btm -e btm"
        "SUPER SHIFT, p, exec, hypr_btm"
      ];

      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:btm"
      ];
    };

    home.shellAliases = {
      top = "btm";
      htop = "btm";
    };

    programs.bottom = {
      settings = {
        flags = {
          # basic = true;
          temperature_type = "c"; # Celsius
          tree = true;
          cpu_as_percentage = true;
          cpu_left_legend = true;
          disable_advanced_kill = true;
        };

        row = [
          # Row 1: Processes and CPU
          {
            child = [
              {type = "proc";}
            ];
          }

          # Row 2: Graphs
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

          # Row 3: Disks and Temp
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
