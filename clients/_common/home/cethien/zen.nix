{pkgs}: let
  tms = import ../../../_tms/home/zen-browser.nix {inherit pkgs;};

  # Prefix every work bookmark recursively, including folder children.
  prefixBookmark = prefix: bookmark:
    (builtins.removeAttrs bookmark ["name" "bookmarks"])
    // {
      name = prefix + bookmark.name;
    }
    // (
      if bookmark ? bookmarks
      then {bookmarks = map (prefixBookmark prefix) bookmark.bookmarks;}
      else {}
    );

  personalBookmarks = [
    {
      name = "ha";
      url = "https://ha.holzrussen.net";
      tags = ["home" "homelab" "home-assistant"];
    }
    {
      name = "gateway";
      url = "http://172.16.1.1";
      tags = ["home" "network" "router"];
    }
  ];
in {
  bookmarks = personalBookmarks ++ map (prefixBookmark "tms-") tms.bookmarks;
  extensions = tms.extensions;
}
