{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.duf;
in
{
  options.deeznuts.programs.duf = {
    enable = mkEnableOption "Enable duf";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duf ];
    home.shellAliases.df = "duf";
  };
}

