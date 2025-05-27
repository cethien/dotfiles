{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
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
      baobab
    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = ["yazi.desktop"];

      # Audio files
      "audio/mpeg" = ["org.gnome.Decibels.desktop"];
      "audio/x-wav" = ["org.gnome.Decibels.desktop"];
      "audio/vnd.wave" = ["org.gnome.Decibels.desktop"];
      "audio/flac" = ["org.gnome.Decibels.desktop"];
      "audio/x-flac" = ["org.gnome.Decibels.desktop"];
      "audio/ogg" = ["org.gnome.Decibels.desktop"];
      "audio/aac" = ["org.gnome.Decibels.desktop"];
      "audio/webm" = ["org.gnome.Decibels.desktop"];
      "audio/mp4" = ["org.gnome.Decibels.desktop"];

      # Archives with File Roller
      "application/zip" = ["org.gnome.FileRoller.desktop"];
      "application/x-tar" = ["org.gnome.FileRoller.desktop"];
      "application/x-compressed-tar" = ["org.gnome.FileRoller.desktop"];
      "application/x-bzip-compressed-tar" = ["org.gnome.FileRoller.desktop"];
      "application/x-xz-compressed-tar" = ["org.gnome.FileRoller.desktop"];
      "application/x-7z-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-rar" = ["org.gnome.FileRoller.desktop"];
      "application/x-cpio" = ["org.gnome.FileRoller.desktop"];
    };
  };
}
