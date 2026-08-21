{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.programs.zen-browser;
  uname = "${config.home.username}";

  binName = "zen-beta";

  autostartFile = pkgs.makeDesktopItem {
    name = "zen-browser-autostart";
    desktopName = "Zen Browser (Autostart)";
    exec = binName;
  };
in {
  options.programs.zen-browser = {
    autostart = mkEnableOption "zen autostart";
    isDefault = mkEnableOption "set zen as default browser";
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    deeznuts.defaultBrowser = mkIf cfg.isDefault binName;

    home.packages = [
      (pkgs.google-fonts.override {
        fonts = ["Roboto"];
      })
    ];

    programs.zen-browser = {
      profiles."${uname}" =
        {
          id = 0;
          name = uname;
        }
        // import ./profile-settings.nix {inherit (pkgs) firefox-addons;};

      policies = {
        ImportEnterpriseRoots = true;
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        # NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };

      languagePacks = [
        "en-US"
        "en-GB"
        "de"
        "ru"
      ];
    };

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/zen-browser-autostart.desktop"
    ];

    stylix.targets.zen-browser.profileNames = ["${uname}"];

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-zen-browser".content = ./hyprland-zen-browser.lua;
    };
  };
}
