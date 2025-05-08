{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.nmap;
in
{
  options.deeznuts.programs.nmap = {
    enable = mkEnableOption "nmap";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ 
      nmap
      netscanner
      dig
    ];
  };
}
