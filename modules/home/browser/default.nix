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
    ./firefox.nix
    ./zen-browser.nix
    ./qutebrowser.nix
    ./chromium.nix
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
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, F, exec, chromium"
    ];

    xdg.mimeApps.defaultApplications = builtins.listToAttrs (map (mime: {
        name = mime;
        value = browserDesktop;
      })
      mimeTypes);

    xdg.desktopEntries = let
      cmd = url: "chromium --app=${url}";
    in {
      chatgpt = {
        name = "ChatGPT";
        exec = "${cmd "https://chatgpt.com"}";
        icon = "chatgpt";
      };

      discord = {
        name = "Discord";
        exec = "${cmd "https://discord.com/channels/@me"}";
        icon = "discord";
      };

      whatsapp = {
        name = "WhatsApp";
        exec = "${cmd "https://web.whatsapp.com"}";
        icon = "whatsapp";
      };
      instagram = {
        name = "Instagram";
        exec = "${cmd "https://instagram.com"}";
        icon = "instagram";
      };
      youtube = {
        name = "YouTube";
        exec = "${cmd "https://youtube.com"}";
        icon = "youtube";
      };

      gmaps = {
        name = "Google Maps";
        exec = "${cmd "https://maps.google.com"}";
        icon = "google-maps";
      };
      gforms = {
        name = "Google Forms";
        exec = "${cmd "https://docs.google.com/forms"}";
        icon = "google-forms";
      };
      gdocs = {
        name = "Google Docs";
        exec = "${cmd "https://docs.google.com/document"}";
        icon = "google-docs";
      };
      gsheets = {
        name = "Google Sheets";
        exec = "${cmd "https://docs.google.com/spreadsheets"}";
        icon = "google-sheets";
      };
      gslides = {
        name = "Google Slides";
        exec = "${cmd "https://docs.google.com/presentation"}";
        icon = "google-slides";
      };
      gdrive = {
        name = "Google Drive";
        exec = "${cmd "https://drive.google.com"}";
        icon = "google-drive";
      };
      gkeep = {
        name = "Google Keep";
        exec = "${cmd "https://keep.google.com"}";
        icon = "google-keep";
      };
      gcal = {
        name = "Google Calendar";
        exec = "${cmd "https://calendar.google.com"}";
        icon = "google-calendar";
      };
      gmail = {
        name = "Google Mail";
        exec = "${cmd "https://mail.google.com"}";
        icon = "gmail";
      };

      "cethien.home" = {
        name = "cethien.home";
        icon = "home";
        exec = "${cmd "https://cethien.home"}";
      };
    };
  };
}
