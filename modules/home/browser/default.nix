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
    default = mkPackageOption pkgs "chromium" {};

    firefox-profile = {
      containers = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = {
      browser = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "default browser workspace";
      };
    };
  };

  config = let
    browserDesktop =
      if builtins.isAttrs cfg.default
      then
        if builtins.hasAttr "desktopFileName" cfg.default.meta
        then cfg.default.meta.desktopFileName
        else "${cfg.default.pname}.desktop"
      else "${cfg.default}.desktop";

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
