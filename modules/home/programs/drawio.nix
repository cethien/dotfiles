{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.drawio;
in
{
  options.deeznuts.programs.drawio = {
    enable = mkEnableOption "Enable Draw.io";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      drawio
    ];
  };
}
