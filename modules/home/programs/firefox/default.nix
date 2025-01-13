{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.firefox;
  name = "${config.home.username}";
in

{
  options.deeznuts.programs.firefox = {
    enable = mkEnableOption "Enable Firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles."${name}" = {
        id = 0;
        inherit name;

        search.default = "DuckDuckGo";

        settings = {
          "browser.aboutwelcome.enabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
          "browser.discovery.enabled" = false;
          "browser.laterrun.enabled" = true;
          "browser.warnOnQuitShortcut" = false;
          "browser.tabs.loadBookmarksInTabs" = true;
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

          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "bookmarks,history";
          "sidebar.backupState" = ''{"width":"","command":"","expanded":false,"hidden":false}'';
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "browser.engagement.sidebar-button.has-used" = true;

          "browser.uiCustomization.horizontalTabsBackup" = ''
            {
              "placements": {
                "widget-overflow-fixed-list": [],
                "unified-extensions-area": [],
                "nav-bar": [
                  "sidebar-button",
                  "back-button",
                  "forward-button",
                  "stop-reload-button",
                  "customizableui-special-spring1",
                  "urlbar-container",
                  "customizableui-special-spring2",
                  "save-to-pocket-button",
                  "downloads-button",
                  "fxa-toolbar-menu-button",
                  "unified-extensions-button"
                ],
                "toolbar-menubar": ["menubar-items"],
                "TabsToolbar": [
                  "firefox-view-button",
                  "tabbrowser-tabs",
                  "new-tab-button",
                  "alltabs-button"
                ],
                "vertical-tabs": [],
                "PersonalToolbar": ["import-button", "personal-bookmarks"]
              },
              "seen": ["save-to-pocket-button", "developer-button"],
              "dirtyAreaCache": ["nav-bar", "vertical-tabs", "PersonalToolbar"],
              "currentVersion": 20,
              "newElementCount": 2
            }
          '';
          "browser.uiCustomization.horizontalTabstrip" = ''["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"]'';
          "browser.uiCustomization.state" = ''
            {
              "placements": {
                "widget-overflow-fixed-list": [],
                "unified-extensions-area": [
                  "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
                ],
                "nav-bar": [
                  "_aba5dba6-dc7b-458d-8587-d8686f815531_-browser-action",
                  "sidebar-button",
                  "customizableui-special-spring1",
                  "back-button",
                  "forward-button",
                  "stop-reload-button",
                  "urlbar-container",
                  "downloads-button",
                  "customizableui-special-spring2",
                  "unified-extensions-button",
                  "_f8829f14-24b7-4e17-8bde-250217de2d71_-browser-action"
                ],
                "toolbar-menubar": ["menubar-items"],
                "TabsToolbar": [],
                "vertical-tabs": ["tabbrowser-tabs"],
                "PersonalToolbar": ["personal-bookmarks"]
              },
              "seen": [
                "save-to-pocket-button",
                "developer-button",
                "_f8829f14-24b7-4e17-8bde-250217de2d71_-browser-action",
                "_aba5dba6-dc7b-458d-8587-d8686f815531_-browser-action",
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
              ],
              "dirtyAreaCache": [
                "nav-bar",
                "vertical-tabs",
                "PersonalToolbar",
                "TabsToolbar",
                "unified-extensions-area",
                "toolbar-menubar"
              ],
              "currentVersion": 20,
              "newElementCount": 6
            }
          '';
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
