{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.drawio;
in {
  options.deeznuts.programs.drawio = {
    enable = mkEnableOption "draw.io";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [drawio];
  };
}
