{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.bc;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.bc = {
    enable = mkEnableOption "bc";
  };

  config = mkIf enabled {
    home.packages = [
      pkgs.bc
    ];
  };
}
