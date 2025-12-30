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
          # ublock lite
          {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";}
          # decentraleyes
          {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";}
          # constant-o-matic
          {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";}
          # i still dont care about cookies
          {id = "edibdbjcniadpccecjdfdjjppcpchdlm";}
          # dont fuck with paste
          {id = "efaagigdgamehbpimpiagfpoihlkgamh";}
          # link cleaner
          {id = "pclbemffjpghlfbdjdifapggphgokeok";}

          # yet another flags
          {id = "dmchcmgddbhmbkakammmklpoonoiiomk";}

          # yang
          {id = "ecboojkidbdghfhifefbpdkdollfhicb";}
          # steamdb
          {id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon";}
          # Twitch Channel Points Auto Clicker
          {id = "jdpblpklojajpopllbckephjndibljbc";}
          # return youtube dislikes
          {id = "gebbhagfogifgggkldgodflihgfeippi";}
          # sponsorblock yt
          {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}

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

    xdg.desktopEntries = let
      cmd = url: "${pkgs.chromium}/bin/chromium --app=${url}";
    in {
      chatgpt = {
        name = "ChatGPT";
        exec = "${cmd "https://chatgpt.com"}";
        icon = "chatgpt";
      };

      discord = {
        name = "Discord";
        exec = "${cmd "https://discord.com/channels/@me"}";
        icon = "discord";
      };

      whatsapp = {
        name = "WhatsApp";
        exec = "${cmd "https://web.whatsapp.com"}";
        icon = "whatsapp";
      };
      instagram = {
        name = "Instagram";
        exec = "${cmd "https://instagram.com"}";
        icon = "instagram";
      };
      youtube = {
        name = "YouTube";
        exec = "${cmd "https://youtube.com"}";
        icon = "youtube";
      };
    };
  };
}
