{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.bottom;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.bottom = {
    enable = mkEnableOption "Enable bottom";
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
  };
}

