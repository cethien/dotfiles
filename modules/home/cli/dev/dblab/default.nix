{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev.dblab;
in
{
  options.deeznuts.cli.dev.dblab = {
    enable = mkEnableOption "Enable dblab";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dblab ];
  };
}
