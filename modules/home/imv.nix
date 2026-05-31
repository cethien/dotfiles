{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.imv;
in {
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      openRulesMerged = {
        "image/*" = [
          {
            name = "imv";
            prio = 1;
          }
        ];
        "image/svg+xml" = [
          {
            name = "imv";
            prio = 1;
          }
        ];
      };
      settings.opener = {
        imv = [
          {
            run = ''imv-dir "$@"'';
            desc = "imv";
            for = "unix";
          }
        ];
      };
    };

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
