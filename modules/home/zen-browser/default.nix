{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts.hyprland) mkWindowRule mkDspBind;

  cfg = config.programs.zen-browser;
  uname = "${config.home.username}";

  ws = config.wayland.windowManager.hyprland.defaultWorkspaces;
in {
  options.programs.zen-browser = {
    autostart = mkEnableOption "zen autostart";
    isDefault = mkEnableOption "set zen as default browser";
  };

  imports = [
    zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    deeznuts.defaultBrowser = mkIf cfg.isDefault "zen-beta";

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

    stylix.targets.zen-browser.profileNames = ["${uname}"];

    wayland.windowManager.hyprland.settings = {
      window_rule = [
        (mkWindowRule {
          initial_class = "^(zen-beta)$";
          title = "^(Developer Tools - .*)$";
        } {tile = true;})
        (mkWindowRule {
            initial_class = "^(zen-beta)$";
            initial_title = "^(Picture-in-Picture)$";
          } {
            workspace = ws.pip;
            no_initial_focus = true;
            suppress_event = "activatefocus";
          })
      ];

      bind = let
        s =
          #lua
          ''
            hl.dsp.exec_cmd("zen-beta")
          '';
      in [
        (mkDspBind "SUPER + W" s {})
      ];
    };
  };
}
