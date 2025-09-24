{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.chromium.enable {
    programs.chromium.package = pkgs.ungoogled-chromium;
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
