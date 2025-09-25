{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.deeznuts.browser;
in {
  imports = [
    ./firefox.nix
    ./zen-browser.nix
    ./picture-in-picture.nix
    ./qutebrowser.nix
  ];

  options.deeznuts.browser = {
    defaultBrowser = mkOption {
      type = types.str;
      default = "";
      description = "default browser name. will be converted to <browser-name>.desktop in mime";
    };

    firefox-profile = {
      containers = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = {
    services.xremap.config.keymap = [
      {
        name = "apps";
        remap."SUPER-SHIFT-f".launch = ["${cfg.defaultBrowser}"];
      }
    ];

    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xht"
        "application/x-extension-xhtml"
        "application/xhtml+xml"
        "text/html"
        "x-scheme-handler/about"
        "x-scheme-handler/chrome"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
        "x-scheme-handler/unknown"
        "x-scheme-handler/webcal"
      ];
    in
      builtins.listToAttrs (map (mime: {
          name = mime;
          value = "${cfg.defaultBrowser}.desktop";
        })
        mimeTypes);
  };
}
