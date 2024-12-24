{ lib, config, ... }:

{
  options.deeznuts.cli.eza.enable = lib.mkEnableOption "Enable eza";

  config = lib.mkIf config.deeznuts.cli.eza.enable {
    programs.eza.enable = true;

    home.shellAliases = {
      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -1a --icons --group-directories-first --git";
      tree = "eza -T --icons";
    };
  };
}
