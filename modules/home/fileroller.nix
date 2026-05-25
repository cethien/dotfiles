{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.fileroller;
in {
  options.programs.fileroller.enable = lib.mkEnableOption "fileroller";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.file-roller];

    xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
      archives = {
        desktop = "org.gnome.FileRoller.desktop";
        types = [
          "application/zip"
          "application/x-tar"
          "application/x-compressed-tar"
          "application/x-bzip-compressed-tar"
          "application/x-xz-compressed-tar"
          "application/x-7z-compressed"
          "application/x-rar"
          "application/x-cpio"
        ];
      };
    };
  };
}
