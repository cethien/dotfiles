{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.lynx;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.lynx = {
    enable = mkEnableOption "lynx text browser";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      lynx
    ];
  };
}
