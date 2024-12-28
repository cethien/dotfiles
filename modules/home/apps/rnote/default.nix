{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.rnote;
in
{
  options.deeznuts.apps.rnote = {
    enable = mkEnableOption "Enable rnote";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ rnote ];
  };
}
