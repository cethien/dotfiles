{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.dblab;
in
{
  options.deeznuts.programs.dblab = {
    enable = mkEnableOption "Enable dblab";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dblab ];
  };
}
