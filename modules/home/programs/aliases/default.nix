{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.aliases;
in
{
  options.deeznuts.programs.aliases = {
    enable = mkEnableOption "Enable shell aliases";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      reload = "source ~/.bashrc && clear";
    };
  };

}
