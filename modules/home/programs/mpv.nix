{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.mpv;
  enable = cfg.enable || config.deeznuts.programs.hyprland.enable;
in {
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

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "video/mp4"
        "video/webm"
        "video/x-matroska"
        "video/ogg"
        "video/x-msvideo"
      ];
    in
      builtins.listToAttrs (map (mimeType: {
          name = mimeType;
          value = ["umpv.desktop"];
        })
        mimeTypes);
  };
}
