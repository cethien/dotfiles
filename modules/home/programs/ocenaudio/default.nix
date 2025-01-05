{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.ocenaudio;
in
{
  options.deeznuts.programs.ocenaudio = {
    enable = mkEnableOption "Enable ocenaudio";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ocenaudio ];
  };
}
