{ lib, config, ... }:

{
  options.deeznuts.cli.shell.aliases = {
    enable = lib.mkEnableOption "Enable shell aliases";
  };

  config = lib.mkIf config.deeznuts.cli.shell.aliases.enable {
    home.shellAliases = {
      reload = "source ~/.bashrc && clear";
    };
  };

}
