{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  deeznuts = {
    storage.enable = true;
    # desktop.gnome.enable = true;

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
      rnote.enable = true;
      keepassxc.enable = true;
      pavucontrol.enable = true;
      easyeffects.enable = true;

      spotify.enable = true;
    };

    terminal.kitty.enable = true;
  };
}
