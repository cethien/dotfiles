{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;

  keepassxcChromiumHost = pkgs.writeTextFile {
    name = "keepassxc-chromium-host";
    destination = "/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
    text = builtins.toJSON {
      name = "org.keepassxc.keepassxc_browser";
      description = "KeePassXC integration with Chromium-based browsers";
      path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
      type = "stdio";
      allowed_origins = [
        "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
        "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
      ];
    };
  };

  keepassxcChromium = pkgs.symlinkJoin {
    name = "keepassxc-with-chromium";
    paths = [pkgs.keepassxc keepassxcChromiumHost];
  };
in {
  config = mkIf config.programs.chromium.enable {
    programs.chromium = {
      # package = pkgs.ungoogled-chromium;
      extensions = mkMerge [
        [
          # yangs
          {id = "ecboojkidbdghfhifefbpdkdollfhicb";}
          # steamdb
          {id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon";}
          # Twitch Channel Points Auto Clicker
          {id = "jdpblpklojajpopllbckephjndibljbc";}
          # return youtube dislikes
          {id = "gebbhagfogifgggkldgodflihgfeippi";}
          # i still dont care about cookies
          {id = "edibdbjcniadpccecjdfdjjppcpchdlm";}
          # sponsorblock yt
          {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
          # ublock lite
          {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";}
          # dark reader
          {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
          {
            id = "dcpihecpambacapedldabdbpakmachpb";
            updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
          }
        ]

        (mkIf config.programs.keepassxc.enable [
          {id = "oboonakemofpalcgghocfoadofidjkkk";}
        ])
      ];

      dictionaries = with pkgs.hunspellDictsChromium; [
        en_US
        de_DE
      ];

      commandLineArgs = [
        "--enable-logging=stderr"
        "--ignore-gpu-blocklist"
      ];

      nativeMessagingHosts = mkMerge [
        (mkIf config.programs.keepassxc.enable [keepassxcChromium])
      ];
    };
  };
}
