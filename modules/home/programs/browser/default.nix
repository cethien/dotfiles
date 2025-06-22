{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.browser;
in {
  imports = [
    ./firefox.nix
    ./zen-browser.nix
    ./picture-in-picture.nix
  ];

  options.deeznuts.programs.browser = {
    defaultBrowser = mkOption {
      type = types.str;
      default = "";
      description = "default browser name. will be converted to <browser-name>.desktop in mime";
    };
  };

  config = {
    xdg.mimeApps.defaultApplications = let
      mimeTypes = [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/mailto"
        "x-scheme-handler/webcal"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
    in
      builtins.listToAttrs (map (mime: {
          name = mime;
          value = "${cfg.defaultBrowser}.desktop";
        })
        mimeTypes);
  };
}
