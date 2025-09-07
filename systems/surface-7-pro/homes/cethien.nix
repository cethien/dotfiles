{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  deeznuts.programs = {
    # gnome.enable = true;

    syncthing.enable = true;
    keepassxc.enable = true;
    pavucontrol.enable = true;
    easyeffects.enable = true;
    browser = {
      zen-browser.enable = true;
      firefox.enable = true;

      defaultBrowser = "zen-beta";
    };

    spotify.enable = true;

    rnote.enable = true;
  };
}
