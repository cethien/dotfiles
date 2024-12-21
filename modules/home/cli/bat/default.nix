{ lib, config, ... }:

{
  options.cli.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.cli.bat.enable {
    programs.bat.enable = true;
    home.shellAliases.cat = "bat -p";
  };
}
