{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.common-gui;
  enabled = cfg.enable;
in {
  options.deeznuts.programs.common-gui = {
    enable = mkEnableOption "common gui for hyprland";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      nautilus
      file-roller
      decibels
      gnome-calculator
    ];

    xdg.mimeApps.defaultApplications = let
      audioMimeTypes = [
        "audio/mpeg"
        "audio/x-wav"
        "audio/vnd.wave"
        "audio/flac"
        "audio/x-flac"
        "audio/ogg"
        "audio/aac"
        "audio/webm"
        "audio/mp4"
      ];
      audioMap = builtins.listToAttrs (map (mimeType: {
          name = mimeType;
          value = ["org.gnome.Decibels.desktop"];
        })
        audioMimeTypes);

      archiveMimeTypes = [
        "application/zip"
        "application/x-tar"
        "application/x-compressed-tar"
        "application/x-bzip-compressed-tar"
        "application/x-xz-compressed-tar"
        "application/x-7z-compressed"
        "application/x-rar"
        "application/x-cpio"
      ];
      archiveMap = builtins.listToAttrs (map (mimeType: {
          name = mimeType;
          value = ["org.gnome.FileRoller.desktop"];
        })
        archiveMimeTypes);
    in
      audioMap // archiveMap;
  };
}
