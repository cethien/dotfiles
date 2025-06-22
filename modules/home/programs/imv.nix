{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.imv;
  enable = cfg.enable || config.deeznuts.programs.hyprland.enable;
in {
  options.deeznuts.programs.imv = {
    enable = mkEnableOption "imv";
  };

  config = mkIf enable {
    programs.imv = {
      enable = true;
    };

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "image/png"
        "image/jpeg"
        "image/webp"
        "image/gif"
        "image/svg+xml"
      ];
    in
      builtins.listToAttrs (map (type: {
          name = type;
          value = ["imv-dir.desktop"];
        })
        mimeTypes);
  };
}
