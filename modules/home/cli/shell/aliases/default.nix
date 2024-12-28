{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.shell.aliases;
in
{
  options.deeznuts.cli.shell.aliases = {
    enable = mkEnableOption "Enable shell aliases";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      reload = "source ~/.bashrc && clear";
    };
  };

}
