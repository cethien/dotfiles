{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.dev.chromium;
in {
  options.deeznuts.programs.dev.chromium = {
    enable = mkEnableOption "chromium browser (for development)";
  };

  config = mkIf cfg.enable {
    programs.chromium.enable = true;
    programs.chromium = {
      package = pkgs.ungoogled-chromium;
    };

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "application/javascript"
        "text/css"
        "application/json"
        "application/manifest+json"
        "application/ld+json"
        "application/xml"
        "text/xml"
        "application/x-www-form-urlencoded"
        "multipart/form-data"
      ];
    in
      builtins.listToAttrs (map (type: {
          name = type;
          value = ["chromium.desktop"];
        })
        mimeTypes);
  };
}
