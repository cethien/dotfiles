{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.procs;
in
{
  options.deeznuts.programs.procs = {
    enable = mkEnableOption "Enable procs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ procs ];
    home.shellAliases.ps = "procs";
  };
}
