{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.deeznuts) mkMimeApps;
  cfg = config.programs.fileroller;
in {
  options.programs.fileroller.enable = lib.mkEnableOption "fileroller";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.file-roller];

    xdg.mimeApps.defaultApplications = mkMimeApps {
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
