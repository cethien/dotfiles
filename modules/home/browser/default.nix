{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkPackageOption;
  cfg = config.deeznuts.browser;
in {
  imports = [
    ./firefox.nix
    ./zen-browser.nix
    ./picture-in-picture.nix
    ./qutebrowser.nix
    ./chromium.nix
  ];

  options.deeznuts.browser = {
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
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, F, exec, chromium"
    ];

    xdg.mimeApps.defaultApplications = builtins.listToAttrs (map (mime: {
        name = mime;
        value = browserDesktop;
      })
      mimeTypes);

    xdg.desktopEntries = let
      quteCmd = url: "chromium --app=${url}";
    in {
      chatgpt = {
        name = "ChatGPT";
        exec = "${quteCmd "https://chatgpt.com"}";
        icon = "chatgpt";
      };
      whatsapp-web = {
        name = "WhatsApp";
        exec = "${quteCmd "https://web.whatsapp.com"}";
        icon = "whatsapp";
      };
      youtube = {
        name = "YouTube";
        exec = "${quteCmd "https://youtube.com"}";
        icon = "youtube";
      };
      gdrive = {
        name = "Google Drive";
        exec = "${quteCmd "https://drive.google.com"}";
        icon = "google-drive";
      };
      gcal = {
        name = "Google Calendar";
        exec = "${quteCmd "https://calendar.google.com"}";
        icon = "google-calendar";
      };
      gmail = {
        name = "Google Mail";
        exec = "${quteCmd "https://mail.google.com"}";
        icon = "gmail";
      };
    };
  };
}
