{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.mpv;
  enable = cfg.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.mpv = {
    enable = mkEnableOption "Enable mpv";
  };

  config = mkIf enable {
    programs.mpv = {
      enable = true;

      config = {
        keep-open = true;
        ytdl-format = "bestvideo+bestaudio";
      };
    };
  };
}
