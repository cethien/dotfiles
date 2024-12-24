{ lib, config, ... }:

{
  options.deeznuts.cli.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.deeznuts.cli.bat.enable {
    programs.bat.enable = true;
    home.shellAliases.cat = "bat -p";
  };
}
