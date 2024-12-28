{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.duf;
in
{
  options.deeznuts.cli.duf = {
    enable = mkEnableOption "Enable duf";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duf ];
    home.shellAliases.df = "duf";
  };
}

