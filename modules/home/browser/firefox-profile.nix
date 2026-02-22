{
  config,
  lib,
  pkgs,
  name,
  ...
}: let
  inherit (lib) mkIf mkMerge;
in {
  profiles."${name}" = {
    id = 0;
    inherit name;

    search = {
      default = "google";
      privateDefault = "ddg";
      order = ["google" "ddg"];
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

            darkreader
          ]

          (mkIf config.programs.keepassxc.enable [
            keepassxc-browser
          ])
        ];
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

  policies = {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
  };
}
