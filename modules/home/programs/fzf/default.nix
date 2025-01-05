{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fzf;
in
{
  options.deeznuts.programs.fzf = {
    enable = mkEnableOption "Enable fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf.enable = true;
  };
}
