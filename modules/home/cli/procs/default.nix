{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.procs.enable = lib.mkEnableOption "Enable procs";

  config = lib.mkIf config.deeznuts.cli.procs.enable {
    home.packages = with pkgs; [ procs ];
    home.shellAliases.ps = "procs";
  };
}
