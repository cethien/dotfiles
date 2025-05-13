{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.bottom;
in
{
  options.deeznuts.programs = {
    bottom.enable = mkEnableOption "bottom (cli monitoring tool)";
  };

  config = mkIf cfg.enable {
    programs.bottom = {
      enable = true;

      settings = {
        flags = {
          temperature_type = "c"; # Celsius
          rate_unit = "b";
          tree = true;
          process_command = true;
          cpu_as_percentage = true;
        };
      };
    };

    home.shellAliases = {
      top = "btm";
      htop = "btm";
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, p, exec, $terminal --class monitor -e btm"
      ];
    };
  };
}

