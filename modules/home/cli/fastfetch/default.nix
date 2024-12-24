{ lib, config, ... }:

{
  options.deeznuts.cli.fastfetch.enable = lib.mkEnableOption "Enable fastfetch";

  config = lib.mkIf config.deeznuts.cli.fastfetch.enable {
    programs.fastfetch.enable = true;
  };
}
