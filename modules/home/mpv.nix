{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.mpv;
in {
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      bindings = {
        "+" = "add volume 5";
        "-" = "add volume -5";
        "UP" = "playlist-prev";
        "DOWN" = "playlist-next";
      };

      config = {
        keep-open = true;
        ytdl-format = "bestvideo+bestaudio";
        wayland-content-type = "none";
        target-colorspace-hint = "no";

        osc = "no";
        osd-bar = "no";
        border = "no";
      };

      scripts = with pkgs.mpvScripts; [
        uosc
        evafast
        thumbfast
        dynamic-crop

        youtube-upnext
        sponsorblock-minimal
        # sponsorblock
        quality-menu

        mpris
        memo
        cutter
        easycrop
        videoclip
        mpv-webm
        convert
        chapterskip
      ];
    };

    xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
      videos = {
        desktop = "umpv.desktop";
        types = [
          "audio/mpeg"
          "audio/x-wav"
          "audio/vnd.wave"
          "audio/flac"
          "audio/x-flac"
          "audio/ogg"
          "audio/aac"
          "audio/webm"
          "audio/mp4"
          "video/mp4"
          "video/webm"
          "video/x-matroska"
          "video/ogg"
          "video/x-msvideo"
        ];
      };
    };
  };
}
