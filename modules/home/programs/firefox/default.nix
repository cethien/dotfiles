{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.firefox;
  name = "${config.home.username}";
in

{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles."${name}" = {
        id = 0;
        inherit name;

        search = {
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
        };

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
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.startup.page" = 3;
          "browser.shell.checkDefaultBrowser" = false;
          "extensions.pocket.enabled" = false;
          "browser.toolbarbuttons.introduced.pocket-button" = false;
          "browser.toolbars.bookmarks.visibility" = "never";

          "media.videocontrols.picture-in-picture.video-toggle.has-used" = true;

          "widget.disable-workspace-management" = true;

          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;

          "extensions.autoDisableScopes" = 0;

          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.main.tools" = "bookmarks,history";
          "sidebar.backupState" = ''{"width":"","command":"","expanded":false,"hidden":false}'';
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "browser.engagement.sidebar-button.has-used" = true;

          "browser.uiCustomization.horizontalTabstrip" = ''["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"]'';

          "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["sponsorblocker_ajay_app-browser-action","_testpilot-containers-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","side-view_mozilla_org-browser-action"],"nav-bar":["customizableui-special-spring1","back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","customizableui-special-spring2","unified-extensions-button","addon_darkreader_org-browser-action","ublock0_raymondhill_net-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","keepassxc-browser_keepassxc_org-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","addon_darkreader_org-browser-action","_testpilot-containers-browser-action","keepassxc-browser_keepassxc_org-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","side-view_mozilla_org-browser-action","sponsorblocker_ajay_app-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":6}'';
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          multi-account-containers
          side-view

          bitwarden
          keepassxc-browser

          ublock-origin
          unpaywall
          istilldontcareaboutcookies
          consent-o-matic
          cookie-autodelete
          link-cleaner

          stylus
          darkreader

          sponsorblock
          return-youtube-dislikes

          twitch-auto-points

          steam-database
        ];

        containers = {
          admin = {
            id = 2;
            color = "red";
            icon = "circle";
          };

          testing = {
            id = 1;
            color = "blue";
            icon = "circle";
          };

          "wörk" = {
            id = 3;
            color = "orange";
            icon = "briefcase";
          };
        };
      };
    };
  };
}
