{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.pinta;
in
{
  options.deeznuts.programs.pinta = {
    enable = mkEnableOption "Enable pinta";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pinta ];
  };
}
