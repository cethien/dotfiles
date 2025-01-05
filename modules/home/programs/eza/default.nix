{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.eza;
in
{
  options.deeznuts.programs.eza = {
    enable = mkEnableOption "Enable eza";
  };

  config = mkIf cfg.enable {
    programs.eza.enable = true;
    home.shellAliases = {
      ll = "eza -la --icons --group-directories-first --git";
      ls = "eza -1a --icons --group-directories-first --git";
      tree = "eza -T --icons";
    };
  };
}
