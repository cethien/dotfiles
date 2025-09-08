{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.deeznuts.browser;
in {
  imports = [
    ./firefox.nix
    ./zen-browser.nix
    ./picture-in-picture.nix
  ];

  options.deeznuts.browser = {
    defaultBrowser = mkOption {
      type = types.str;
      default = "";
      description = "default browser name. will be converted to <browser-name>.desktop in mime";
    };

    firefox-profile = {
      containers = {
        "potato-squad.de".enable = mkOption {
          type = types.bool;
          default = false;
          description = "enable container for potato-squad.de";
        };

        "creative-europe.net".enable = mkOption {
          type = types.bool;
          default = false;
          description = "enable container for creative-europe.net";
        };
      };
    };
  };

  config = {
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
