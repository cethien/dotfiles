{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.deeznuts.programs.browser;
in {
  imports = [
    ./firefox.nix
    ./zen-browser.nix
    ./picture-in-picture.nix
  ];

  options.deeznuts.programs.browser = {
    xmimeDefault = mkOption {
      type = types.str;
      default = null;
      description = "which desktop file should be used for web related xMime defaults";
      example = "firefox.desktop";
    };
  };

  config = {
    xdg.mimeApps.defaultApplications = mkIf (cfg.xmimeDefault
      != null) {
      "x-scheme-handler/http" = [cfg.xmimeDefault];
      "x-scheme-handler/https" = [cfg.xmimeDefault];
      "x-scheme-handler/about" = [cfg.xmimeDefault];
      "x-scheme-handler/unknown" = [cfg.xmimeDefault];
      "text/html" = [cfg.xmimeDefault];
      "application/xhtml+xml" = [cfg.xmimeDefault];
    };
  };
}
