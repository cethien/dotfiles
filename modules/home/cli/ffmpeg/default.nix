{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.ffmpeg;
in
{
  options.deeznuts.cli.ffmpeg = {
    enable = mkEnableOption "Enable ffmpeg";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ffmpeg ];
  };
}
