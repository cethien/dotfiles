{pkgs, ...}: {
  config = {
    programs.qutebrowser = {
      perDomainSettings = {
        "web.whatsapp.com" = {
          content.media.audio_capture = true;
        };
        "discord.com" = {
          content = {
            autoplay = true;
            media.audio_video_capture = true;
            desktop_capture = true;
            javascript.clipboard = "access";
          };
        };

        "chatgpt.com" = {
          content.javascript.clipboard = "access";
        };

        "github.com" = {
          colors.webpage.darkmode.enabled = false;
          content.javascript.clipboard = "access";
        };

        "maps.google.com" = {
          content.geolocation = true;
        };
      };

      quickmarks = {
        mail = "https://mail.google.com/";
        cal = "https://calendar.google.com/";
        drive = "https://drive.google.com/";
        notes = "https://keep.google.com/";

        spt = "https://open.spotify.com/";
        sptpls = "https://playlistsorter.com/";
        dc = "https://discord.com/";
        wa = "https://web.whatsapp.com/";
        yt = "https://youtube.com/";

        chat = "https://chatgpt.com/";

        nvf = "https://notashelf.github.io/nvf/options.html";
      };

      searchEngines = {
        hm = "https://home-manager-options.extranix.com/?query={}&release=master";

        nixdoc = "https://nix.dev/search.html?q={}";
        nixwiki = "https://wiki.nixos.org/w/index.php?search={}";
        nixpkgs = "https://nixos.org/nixos/packages.html?query={}";

        steamdb = "http://steamdb.info/search/?a=app&q={}";
        steam = "https://store.steampowered.com/search/?term={}";
        gh = "https://github.com/search?q={}";
        wiki = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        spt = "https://open.spotify.com/search/{}";

        am = "https://www.amazon.de/s?k={}";
        yt = "https://www.youtube.com/results?search_query={}";
        ytdate = "https://www.youtube.com/results?search_query={}&search_sort=video_date_uploaded";

        g = "https://www.google.com/search?hl=en&q={}";
      };

      keyBindings = {
        normal = {
          "<Alt-Left>" = "back";
          "<Alt-Right>" = "forward";
        };
      };

      greasemonkey = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_adblock.js";
          sha256 = "sha256-AyD9VoLJbKPfqmDEwFIEBMl//EIV/FYnZ1+ona+VU9c=";
        })

        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_shorts_block.js";
          sha256 = "sha256-e9qCSAuEMoNivepy7W/W5F9D1PJZrPAJoejsBi9ejiY=";
        })

        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_sponsorblock.js";
          sha256 = "sha256-nwNade1oHP+w5LGUPJSgAX1+nQZli4Rhe8FFUoF5mLE=";
        })
      ];

      settings = {
        scrolling.smooth = true;
        downloads.location = {
          prompt = false;
          directory = "~/Downloads";
        };

        tabs = {
          show = "multiple";
        };

        statusbar.show = "in-mode";
        colors.webpage.preferred_color_scheme = "dark";
        completion.use_best_match = true;
        confirm_quit = ["downloads"];
        # auto_save.session = true;
        # session.lazy_restore = true;

        content = {
          notifications.enabled = false;
        };
      };

      loadAutoconfig = true;
    };

    xdg.desktopEntries = let
      quteCmd = "qutebrowser --target window";
    in {
      chatgpt = {
        name = "ChatGPT";
        exec = ''${quteCmd} "https://chatgpt.com"'';
        icon = "chatgpt";
      };
      whatsapp-web = {
        name = "WhatsApp";
        exec = ''${quteCmd} "https://web.whatsapp.com"'';
        icon = "whatsapp";
      };
      youtube = {
        name = "YouTube";
        exec = ''${quteCmd} "https://youtube.com"'';
        icon = "youtube";
      };
      gdrive = {
        name = "Google Drive";
        exec = ''${quteCmd} "https://drive.google.com"'';
        icon = "gdrive";
      };
      gcal = {
        name = "Google Calendar";
        exec = ''${quteCmd} "https://calendar.google.com"'';
        icon = "gcalendar";
      };
      gmail = {
        name = "Google Mail";
        exec = ''${quteCmd} "https://mail.google.com"'';
        icon = "gmail";
      };
    };
  };
}
