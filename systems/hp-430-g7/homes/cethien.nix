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

  stylix.image = ../../../wallpapers/a_hand_holding_a_cassette_tape.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "HDMI-A-1, 2560x1440@60, 0x0, 1"
        "eDP-1, 1920x1080@60, 320x1440, 1"
      ];

      workspace = [
        "1, monitor:HDMI-A-1, persistent:true" # browser
        "2, monitor:HDMI-A-1, persistent:true" # general
        "3, monitor:HDMI-A-1, persistent:true" # general
        "4, monitor:HDMI-A-1, persistent:true" # general
        "5, monitor:HDMI-A-1, persistent:true" # general

        "6, monitor:eDP-1, persistent:true" # general
        "7, monitor:eDP-1, persistent:true" # spotify
        "8, monitor:eDP-1" # btm
        "9, monitor:eDP-1" # discord
        "10, monitor:eDP-1" # obs
      ];
    };
    defaultWorkspaces = {
      browser = 1;
      gaming = 4;
    };
    autostart = [
      "keepassxc"
      "spotify"
    ];
  };

  home.packages = [pkgs.simple-scan];

  programs = {
    kitty.enable = true;
    chromium.enable = true;
    keepassxc.enable = true;
    devSuite.extras = ["containers"];
    distrobox.enable = true;
    creativeSuite = {
      enable = true;
      extras = ["mixxx"];
    };
    spotify.enable = true;
    discord.enable = true;
  };

  deeznuts = {
    browser = {
      firefox-profile.containers = [
        "potato-squad.de"
        "creative-europe.net"
      ];
    };
  };
}
