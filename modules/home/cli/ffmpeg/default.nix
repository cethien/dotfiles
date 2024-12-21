{ lib, config, pkgs, ... }:

{
  options.cli.ffmpeg.enable = lib.mkEnableOption "Enable ffmpeg";

  config = lib.mkIf config.cli.ffmpeg.enable {
    home.packages = with pkgs; [ ffmpeg ];
  };
}
