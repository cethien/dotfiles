{
  config,
  lib,
  pkgs,
  name,
  ...
}: let
  inherit (lib) elem mkIf mkMerge;
  cfg = config.programs.browser;
in {
  profiles."${name}" = let
    potato = elem "potato-squad.de" cfg.firefox-profile.containers;
    creative = elem "creative-europe.net" cfg.firefox-profile.containers;
    tms = elem "tmsproshop.de" cfg.firefox-profile.containers;
    tms-admin = elem "tmsproshop.de/admin" cfg.firefox-profile.containers;
  in {
    id = 0;
    inherit name;

    containers = {
      "alt acc" = {
        id = 1;
        color = "turquoise";
        icon = "circle";
      };

      admin = {
        id = 2;
        color = "red";
        icon = "circle";
      };

      "potato-squad.de" = mkIf potato {
        id = 3;
        color = "orange";
        icon = "fruit";
      };

      "creative-europe.net" = mkIf creative {
        id = 4;
        color = "yellow";
        icon = "vacation";
      };

      "tmsproshop.de" = mkIf tms {
        id = 5;
        color = "green";
        icon = "briefcase";
      };

      "tmsproshop.de/admin" = mkIf tms-admin {
        id = 6;
        color = "red";
        icon = "briefcase";
      };
    };

    extensions = {
      packages = with pkgs.nur.repos.rycee.firefox-addons;
        mkMerge [
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

            # darkreader
            dark-mode-website-switcher
          ]

          (mkIf config.programs.keepassxc.enable [
            keepassxc-browser
          ])
        ];
    };

    search = {
      default = "google";
      privateDefault = "ddg";
      order = ["google" "ddg"];
    };

    settings = {
      "browser.aboutwelcome.enabled" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
      "browser.discovery.enabled" = false;
      "browser.laterrun.enabled" = true;
      "browser.warnOnQuitShortcut" = false;
      "browser.tabs.loadBookmarksInTabs" = true;
      "browser.tabs.warnOnClose" = true;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "trailhead.firstrun.didSeeAboutWelcome" = true;
      "signon.management.page.breach-alerts.enabled" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "privacy.donottrackheader.enabled" = true;
      "privacy.globalprivacycontrol.enabled" = true;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.quicksuggest.scenario" = "bookmarks";
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.ssb.enabled" = true;
      "browser.ctrlTab.sortByRecentlyUsed" = true;
      "extensions.autoDisableScopes" = 0;
      "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;
      "signon.rememberSignons" = false;
      "signon.autofillForms" = false;
      "browser.startup.page" = 3;
      "browser.shell.checkDefaultBrowser" = false;
    };
  };

  nativeMessagingHosts = mkMerge [
    (mkIf config.programs.keepassxc.enable [pkgs.keepassxc])
  ];

  languagePacks = [
    "en-US"
    "en-GB"
    "de"
    "ru"
  ];
}
