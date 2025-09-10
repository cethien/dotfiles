{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  stylix.image = ../../../wallpapers/a_hand_holding_a_cassette_tape.jpg;

  deeznuts = {
    storage.enable = true;

    desktop.hyprland = {
      enable = true;
      monitors = [
        "HDMI-A-1, 2560x1440@60, 0x0, 1"
        "eDP-1, 1920x1080@60, 320x1440, 1"
      ];

      workspaces = [
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

      defaultWorkspaces = {
        browser = 1;
        gaming = 4;
      };
    };

    terminal.kitty.enable = true;
    audio.enable = true;
    browser = {
      firefox-profile.containers = {
        "potato-squad.de".enable = true;
        "creative-europe.net".enable = true;
      };

      firefox.enable = true;
      zen-browser.enable = true;
      zen-browser.hyprland.autostart.enable = true;

      defaultBrowser = "zen-beta";
    };

    programs = {
      essentials.tmux.hyprland.autostart.enable = true;
      docker.enable = true;
      dev = {
        vscode.enable = true;
        chromium.enable = true;
      };

      gaming.enable = true;

      keepassxc.enable = true;
      keepassxc.hyprland.autostart.enable = true;

      discord.enable = true;
      spotify.enable = true;
      spotify.hyprland.autostart.enable = true;
    };

    creative = {
      enable = true;
      mixxx.enable = true;
    };
  };
}
