{ lib, config, ... }:

{
  options.cli.bottom.enable = lib.mkEnableOption "Enable bottom";

  config = lib.mkIf config.cli.bottom.enable {
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
  };
}

