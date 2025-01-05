{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.ffmpeg;
in
{
  options.deeznuts.programs.ffmpeg = {
    enable = mkEnableOption "Enable ffmpeg";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ffmpeg ];
  };
}
