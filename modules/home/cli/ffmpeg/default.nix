{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.ffmpeg.enable = lib.mkEnableOption "Enable ffmpeg";

  config = lib.mkIf config.deeznuts.cli.ffmpeg.enable {
    home.packages = with pkgs; [ ffmpeg ];
  };
}
