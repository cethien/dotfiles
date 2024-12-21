{ lib, config, ... }:

{
  options.cli.fastfetch.enable = lib.mkEnableOption "Enable fastfetch";

  config = lib.mkIf config.cli.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
