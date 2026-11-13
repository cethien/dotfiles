{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.deeznuts) mkMimeApps;
  cfg = config.programs.imv;
  imageOpeners = [
    {
      name = "imv";
      prio = 10;
    }
    {
      name = "open";
      prio = 60;
    }
    {
      name = "reveal";
      prio = 90;
    }
  ];
in {
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      openRulesMerged = {
        "image/*" = imageOpeners;
        "image/svg+xml" = imageOpeners;
      };
      settings.opener = {
        imv = [
          {
            run = ''imv-dir %s'';
            desc = "imv";
            for = "unix";
            orphan = true;
          }
        ];
      };
    };

    xdg.mimeApps.defaultApplications = mkMimeApps {
      images = {
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
