{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.firefox.enable = lib.mkEnableOption "Enable Firefox";

  config = lib.mkIf config.deeznuts.apps.firefox.enable {
    programs.firefox = {
      enable = true;

      profiles."${config.home.username}" = {
        id = 0;
        name = "${config.home.username}";

        search.default = "DuckDuckGo";

        settings = {
          "browser.aboutwelcome.enabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
          "browser.discovery.enabled" = false;
          "browser.laterrun.enabled" = true;
          "browser.warnOnQuitShortcut" = false;
          "browser.tabs.loadBookmarksInTabs" = true;
          "browser.search.openintab" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "signon.management.page.breach-alerts.enabled" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.ssb.enabled" = true;
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          multi-account-containers
          side-view
          ublock-origin
          bitwarden
        ];
      };
    };
  };
}
