{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.bat;
in
{
  options.deeznuts.programs.bat = {
    enable = mkEnableOption "Enable bat";
  };

  config = mkIf cfg.enable {
    programs.bat.enable = true;
    home.shellAliases.cat = "bat -p";
  };
}
