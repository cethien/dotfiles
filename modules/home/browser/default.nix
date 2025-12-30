{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkPackageOption;
  cfg = config.programs.browser;
in {
  imports = [
    ./chromium.nix
    ./firefox.nix
    ./zen-browser.nix
  ];

  options.programs.browser = {
    defaultBrowser = mkPackageOption pkgs "chromium" {};

    firefox-profile = {
      containers = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = let
    browserDesktop =
      if builtins.isAttrs cfg.defaultBrowser
      then
        if builtins.hasAttr "desktopFileName" cfg.defaultBrowser.meta
        then cfg.defaultBrowser.meta.desktopFileName
        else "${cfg.defaultBrowser.pname}.desktop"
      else "${cfg.defaultBrowser}.desktop";

    mimeTypes = [
      "application/javascript"
      "application/json"
      "application/ld+json"
      "application/manifest+json"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/x-extension-xht"
      "application/x-extension-xhtml"
      "application/x-www-form-urlencoded"
      "application/xhtml+xml"
      "application/xml"
      "multipart/form-data"
      "text/css"
      "text/html"
      "text/plain"
      "text/xml"
      "x-scheme-handler/about"
      "x-scheme-handler/chrome"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/mailto"
      "x-scheme-handler/unknown"
    ];
  in {
    xdg.mimeApps.defaultApplications = builtins.listToAttrs (map (mime: {
        name = mime;
        value = browserDesktop;
      })
      mimeTypes);
  };
}
