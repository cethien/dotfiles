{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.libreoffice;
in {
  options.programs.libreoffice.enable = mkEnableOption "libreoffice";

  config = mkIf cfg.enable {
    home.packages = [pkgs.libreoffice-fresh];

    xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
      office = {
        desktop = "libreoffice.desktop";
        types = [
          "application/msword"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
          "application/vnd.ms-word.document.macroEnabled.12"
          "application/vnd.ms-word.template.macroEnabled.12"

          "application/vnd.ms-excel"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
          "application/vnd.ms-excel.sheet.macroEnabled.12"
          "application/vnd.ms-excel.template.macroEnabled.12"
          "application/vnd.ms-excel.addin.macroEnabled.12"
          "application/vnd.ms-excel.sheet.binary.macroEnabled.12"

          "application/vnd.ms-powerpoint"
          "application/vnd.openxmlformats-officedocument.presentationml.presentation"
          "application/vnd.openxmlformats-officedocument.presentationml.template"
          "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
          "application/vnd.ms-powerpoint.addin.macroEnabled.12"
          "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
          "application/vnd.ms-powerpoint.template.macroEnabled.12"
          "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"

          "application/vnd.ms-access"
        ];
      };
    };
  };
}
