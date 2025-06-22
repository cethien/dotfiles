{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.office;
in {
  options.deeznuts.programs.office = {
    enable = mkEnableOption "office";
  };

  config = mkIf cfg.enable {
    programs.onlyoffice.enable = true;

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
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
    in
      builtins.listToAttrs (map (mimeType: {
          name = mimeType;
          value = ["onlyoffice-desktopeditors.desktop"];
        })
        mimeTypes);
  };
}
