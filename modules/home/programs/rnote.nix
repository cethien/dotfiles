{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.rnote;
in
{
  options.deeznuts.programs.rnote = {
    enable = mkEnableOption "Enable rnote";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ rnote ];
  };
}
