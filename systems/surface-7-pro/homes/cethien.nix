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
  programs.gnome-shell.enable = true;

  home.packages = with pkgs; [rnote];
  programs = {
    kitty.enable = true;
    keepassxc.enable = true;
    firefox.enable = true;
    zen-browser.enable = true;

    spotify.enable = true;
  };

  deeznuts = {
    storage.enable = true;
    storage.rclone.enable = false;
    audio.enable = true;

    browser = {
      defaultBrowser = "zen-beta";
      firefox-profile.containers = [
        "potato-squad.de"
        "creative-europe.net"
      ];
    };
  };
}
