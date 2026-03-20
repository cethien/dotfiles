{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.mpv = {
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
  };
}
