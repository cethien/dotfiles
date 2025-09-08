{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  stylix.image = ./boy_and_cat_sitting_on_stairs.jpeg;
  deeznuts = {
    storage.enable = true;
    # desktop.gnome.enable = true;

    browser = {
      firefox.enable = true;
      zen-browser.enable = true;
      defaultBrowser = "zen-beta";
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
