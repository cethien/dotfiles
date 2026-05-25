{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.imv;
in {
  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
      videos = {
        desktop = "imv-dir.desktop";
        types = [
          "image/png"
          "image/jpeg"
          "image/webp"
          "image/gif"
          "image/svg+xml"
        ];
      };
    };
  };
}
