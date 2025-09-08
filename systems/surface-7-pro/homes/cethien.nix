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
   
    programs = {
      rnote.enable = true;
      keepassxc.enable = true;
      pavucontrol.enable = true;
      easyeffects.enable = true;
      browser = {
        zen-browser.enable = true;
        firefox.enable = true;

        defaultBrowser = "zen-beta";
      };

      spotify.enable = true;
    };
    
    terminal.kitty.enable = true;
  };
}
