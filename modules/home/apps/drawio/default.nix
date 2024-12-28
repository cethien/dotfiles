{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.drawio;
in
{
  options.deeznuts.apps.drawio = {
    enable = mkEnableOption "Enable Draw.io";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      drawio
    ];
  };
}
