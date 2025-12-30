{
  config,
  lib,
  pkgs,
  name,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = config.programs.browser;
in {
  profiles."${name}" = let
    additionalContainers = [
      {
        name = "potato-squad.de";
        color = "orange";
        icon = "fruit";
      }
      {
        name = "creative-europe.net";
        color = "yellow";
        icon = "vacation";
      }
      {
        name = "tmsproshop.de";
        color = "green";
        icon = "briefcase";
      }
      {
        name = "tmsproshop.de/admin";
        color = "red";
        icon = "briefcase";
      }
    ];

    activeContainers = builtins.filter (c: builtins.elem c.name cfg.firefox-profile.containers) additionalContainers;

    containerSet = builtins.listToAttrs (builtins.genList (i: let
      c = builtins.elemAt activeContainers i;
    in {
      name = c.name;
      value = {
        id = i + 3;
        inherit (c) color icon;
      };
    }) (builtins.length activeContainers));
  in {
    id = 0;
    inherit name;

    bookmarks = {
      force = true;
      settings = [
        {
          bookmarks = [
            {
              name = "mail";
              url = "https://mail.google.com/";
            }
            {
              name = "cal";
              url = "https://calendar.google.com/";
            }
            {
              name = "drive";
              url = "https://drive.google.com/";
            }
            {
              name = "notes";
              url = "https://keep.google.com/";
            }
            {
              name = "gemini";
              url = "https://gemini.google.com/";
            }
            {
              name = "chatgpt";
              url = "https://chatgpt.com/";
            }
            {
              name = "spotify";
              url = "https://open.spotify.com/";
            }
            {
              name = "spotify-playlist-sorter";
              url = "https://playlistsorter.com/";
            }
            {
              name = "discord";
              url = "https://discord.com/";
            }
            {
              name = "whatsapp";
              url = "https://web.whatsapp.com/";
            }
            {
              name = "youtube";
              url = "https://youtube.com/";
            }
          ];
        }
      ];
    };

    search = {
      default = "google";
      privateDefault = "ddg";
      order = ["google" "ddg"];
    };

    containers =
      {
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
      }
      // containerSet;
    containersForce = true;

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

    settings = {
      browser = {
        aboutConfig.showWarning = false;
        crashReports.unsubmittedCheck.autoSubmit2 = true;
        ctrlTab.sortByRecentlyUsed = true;
        discovery.enabled = false;
        laterrun.enabled = true;
        newtabpage.activity-stream.showSponsoredTopSites = false;
        shell.checkDefaultBrowser = false;
        ssb.enabled = true;
        startup.page = 3;
        tabs = {
          loadBookmarksInTabs = true;
          warnOnClose = true;
        };
        urlbar = {
          quicksuggest.scenario = "bookmarks";
          suggest.quicksuggest.sponsored = false;
        };
        warnOnQuitShortcut = false;
      };

      media.videocontrols.picture-in-picture.video-toggle.has-used = true;

      extensions = {
        autoDisableScopes = 0;
        formautofill = {
          addresses.enabled = false;
          creditCards.enabled = false;
        };
      };

      privacy = {
        donottrackheader.enabled = true;
        globalprivacycontrol.enabled = true;
      };

      signon = {
        autofillForms = false;
        management.page.breach-alerts.enabled = false;
        rememberSignons = false;
      };

      toolkit.telemetry.reportingpolicy.firstRun = false;
      trailhead.firstrun.didSeeAboutWelcome = true;
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
