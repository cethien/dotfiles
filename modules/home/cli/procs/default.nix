{ lib, config, pkgs, ... }:

{
  options.cli.procs.enable = lib.mkEnableOption "Enable procs";

  config = lib.mkIf config.cli.procs.enable {
    home.packages = with pkgs; [ procs ];
    home.shellAliases.ps = "procs";
  };
}
