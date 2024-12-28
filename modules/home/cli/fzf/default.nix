{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.fzf;
in
{
  options.deeznuts.cli.fzf = {
    enable = mkEnableOption "Enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;
  };
}
