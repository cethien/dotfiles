{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.bat;
in
{
  options.deeznuts.cli.bat = {
    enable = mkEnableOption "Enable bat";
  };

  config = mkIf cfg.enable {
    programs.bat.enable = true;
    home.shellAliases.cat = "bat -p";
  };
}
