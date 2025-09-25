{pkgs, ...}: {
  config = {
    programs.qutebrowser = {
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

      greasemonkey = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1d1be041a65c251692ee082eda64d2637edf6444/youtube_sponsorblock.js";
          sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
        })
      ];

      keyBindings = {
        normal = {
          "<Alt-Left>" = "back";
          "<Alt-Right>" = "forward";
        };
      };

      settings = {
        scrolling.smooth = true;
        downloads.location = {
          prompt = false;
          directory = "~/Downloads";
        };

        tabs = {
          show = "multiple";
          # tabs_are_windows = true;
        };

        statusbar.show = "in-mode";
        content.notifications.enabled = false;
        completion.use_best_match = true;
        confirm_quit = ["downloads"];
        auto_save.session = true;
        session.lazy_restore = true;
      };
    };
  };
}
