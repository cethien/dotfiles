{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.mpv;
  enable = cfg.enable || config.deeznuts.programs.hyprland.enable;
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

    xdg.mimeApps.defaultApplications = {
      # Video files
      "video/mp4" = [ "umpv.desktop" ];
      "video/webm" = [ "umpv.desktop" ];
      "video/x-matroska" = [ "umpv.desktop" ];
      "video/ogg" = [ "umpv.desktop" ];
      "video/x-msvideo" = [ "umpv.desktop" ];
    };
  };
}
