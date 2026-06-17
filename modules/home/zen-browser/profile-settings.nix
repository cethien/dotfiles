{firefox-addons, ...}: {
  extensions.packages = with firefox-addons; [
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

    fx_cast
  ];

  mods = [
    "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
    "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
    "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
    "cb5efa80-f1e1-43ce-8c0b-fece8462d225" # Container Halo
    "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
    "87196c08-8ca1-4848-b13b-7ea41ee830e7" # Tab Preview Enhanced
    "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better CtrlTab Panel
    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
    "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
  ];

  search = {
    default = "google";
    privateDefault = "ddg";
    order = ["google" "ddg"];
  };
  search.force = true;

  keyboardShortcutsVersion = 19;
  keyboardShortcuts = [
    {
      id = "zen-compact-mode-toggle";
      key = "c";
      modifiers = {
        control = true;
        alt = true;
      };
    }
    {
      id = "key_togglePictureInPicture";
      key = "p";
      modifiers = {
        control = true;
        alt = true;
      };
    }
  ];

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
}
