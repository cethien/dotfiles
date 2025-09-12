{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  stylix.image = ../../../wallpapers/boy_and_cat_sitting_on_stairs.jpeg;

  deeznuts = {
    storage.enable = true;
    desktop.gnome.enable = true;
    audio.enable = true;

    terminal.kitty.enable = true;
    browser = {
      firefox.enable = true;
      zen-browser.enable = true;
      defaultBrowser = "zen-beta";

      firefox-profile.containers = {
        "potato-squad.de".enable = true;
        "creative-europe.net".enable = true;
      };
    };
    programs = {
      keepassxc = {
        enable = true;
      };
      spotify.enable = true;
      rnote.enable = true;
    };
  };
}
