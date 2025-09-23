{
  stateVersion,
  pkgs,
  ...
}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  stylix.image = ../../../wallpapers/boy_and_cat_sitting_on_stairs.jpeg;

  home.packages = with pkgs; [rnote];

  programs = {
    keepassxc.enable = true;
    kitty.enable = true;
  };

  deeznuts = {
    storage.enable = true;
    desktop.gnome.enable = true;
    audio.enable = true;

    terminal.kitty.enable = true;
    browser = {
      firefox.enable = true;
      zen-browser.enable = true;
      defaultBrowser = "zen-beta";

      firefox-profile.containers = [
        "potato-squad.de"
        "creative-europe.net"
      ];
    };
    programs = {
      spotify.enable = true;
    };
  };
}
