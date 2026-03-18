{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.programs.zen-browser;
  name = "${config.home.username}";
  addons = pkgs.nur.repos.rycee.firefox-addons;

  as = elem "zen-browser" config.wayland.windowManager.hyprland.autostart;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.browser;
in {
  imports = [
    zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser.suppressXdgMigrationWarning = true;
    programs.zen-browser = {
      profiles."${name}" = {
        extensions.packages = with addons;
          [
            multi-account-containers

            ublock-origin
            decentraleyes
            consent-o-matic
            istilldontcareaboutcookies
            cookie-autodelete
            don-t-fuck-with-paste
            unpaywall
            sponsorblock
            return-youtube-dislikes
            twitch-auto-points
            link-cleaner

            flagfox
            yang
            steam-database

            darkreader
          ]
          ++ lib.optionals config.programs.keepassxc.enable [
            addons.keepassxc-browser
          ];

        mods = [
          "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
          "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
          "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
          "cb5efa80-f1e1-43ce-8c0b-fece8462d225" # Container Halo
          "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
          "87196c08-8ca1-4848-b13b-7ea41ee830e7" # Tab Preview Enhanced
          "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
        ];

        search = {
          default = "google";
          privateDefault = "ddg";
          order = ["google" "ddg"];
        };
        search.force = true;

        settings = {
          "zen.welcome-screen.seen" = true;
          "zen.mediacontrols.enabled" = false;
          "zen.workspaces.continue-where-left-off" = true;
          "zen.view.use-single-toolbar" = false;
          "zen.view.show-clear-tabs-button" = false;

          "identity.fxaccounts.enabled" = false;

          "browser.aboutConfig.showWarning" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.discovery.enabled" = false;
          "browser.laterrun.enabled" = true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.ssb.enabled" = true;
          "browser.tabs.warnOnClose" = false;
          "browser.urlbar.quicksuggest.scenario" = "bookmarks";
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.warnOnQuitShortcut" = false;
          "browser.search.suggest.enabled" = true;
          "browser.tabs.inTitlebar" = 0;
          "browser.translations.neverTranslateLanguages" = "de,ru";

          "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;

          "extensions.autoDisableScopes" = 0;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;

          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;

          "signon.autofillForms" = false;
          "signon.management.page.breach-alerts.enabled" = false;
          "signon.rememberSignons" = false;

          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "security.enterprise_roots.enable" = true;
        };

        id = 0;
        inherit name;
      };

      nativeMessagingHosts = lib.optionals (config.programs.keepassxc.enable) [pkgs.keepassxc];

      languagePacks = [
        "en-US"
        "en-GB"
        "de"
        "ru"
      ];

      policies = {
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
    };

    stylix.targets.zen-browser.profileNames = ["${name}"];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common.default = "*";
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["[silent] zen-beta"];
      windowrule = ["match:class ^(zen-beta)$, tile on"];
      bind = let
        script = pkgs.writeShellScriptBin "hypr_zen-sidebar" ''
          DESIGNATED_WS=${toString ws}
          BROWSER_WS=$(hyprctl -j clients \
            | jq -r '.[] | select(.initialClass=="zen-beta") | .workspace.id' \
            | head -n1)

          WS_JSON=$(hyprctl -j activeworkspace)
          ACTIVE_WS=$(echo "$WS_JSON" | jq -r '.id')
          HAS_FULLSCREEN=$(echo "$WS_JSON" | jq -r '.hasfullscreen')

          if [ -z "$BROWSER_WS" ]; then
            zen-beta &
            exit 0
          fi

          if [ -n "$DESIGNATED_WS" ] && [ "$BROWSER_WS" = "$ACTIVE_WS" ] || [ "$HAS_FULLSCREEN" = "true" ]; then
            hyprctl dispatch movetoworkspacesilent $DESIGNATED_WS,initialclass:zen-beta
          else
            hyprctl dispatch movetoworkspace $ACTIVE_WS,initialclass:zen-beta
          fi
        '';
      in [
        "SUPER SHIFT, W, exec, ${script}/bin/hypr_zen-sidebar"
      ];
    };
  };
}
