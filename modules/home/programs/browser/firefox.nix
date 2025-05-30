{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.browser.firefox;
  name = "${config.home.username}";
in {
  options.deeznuts.programs.browser.firefox = {
    enable = mkEnableOption "firefox";
    hyprland = {
      workspace = mkOption {
        type = types.int;
        default = config.deeznuts.programs.hyprland.defaultWorkspaces.browser;
        description = "default workspace";
      };
      autostart.enable = mkEnableOption "autostart";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
    programs.firefox = {
      profiles."${name}" = {
        id = 0;
        inherit name;

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

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          multi-account-containers

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
          "extensions.pocket.enabled" = false;
          "browser.toolbarbuttons.introduced.pocket-button" = false;
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "sidebar.main.tools" = "bookmarks,history";
          "sidebar.new-sidebar.has-used" = true;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "widget.disable-workspace-management" = true;
          "browser.uiCustomization.horizontalTabstrip" = ''["tabbrowser-tabs","new-tab-button"]'';
        };
      };

      languagePacks = [
        "en-US"
        "en-GB"
        "de"
        "ru"
      ];
    };

    stylix.targets.firefox.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] firefox"
      ];
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(firefox)$"
      ];
    };
  };
}
