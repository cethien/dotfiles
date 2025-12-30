{
  stateVersion,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  stylix.image = ../../wallpapers/boy_and_cat_sitting_on_stairs.jpeg;
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

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice];

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  programs = {
    ssh.matchBlocksExtra =
      (import ../../homes/tmsproshop.de/ssh.nix)
      // {
        "homelab" = {
          user = "cethien";
          host = "homelab";
          hostname = "192.168.1.50";
        };
      };
    freerdp.enable = true;
    freerdp.connections = import ../../homes/tmsproshop.de/rdp.nix;
    browser.firefox-profile.containers = ["tmsproshop.de" "tmsproshop.de/admin"];

    git.urlExtra = {
      "ssh://git@git.cethien.home".insteadOf = "https://git.cethien.home";
      "git@git.cethien.home:".insteadOf = "home:";
    };

    kitty.enable = true;
    chromium.enable = true;
    keepassxc.enable = true;
    gemini-cli.enable = true;

    thunderbird.enable = true;
    thunderbird.profiles."borislaw.sotnikow@gmx.de".isDefault = true;

    devSuite.extras = ["containers"];

    creativeSuite = {
      enable = true;
      extras = ["mixxx"];
    };
    spotify.enable = true;
    vesktop.enable = true;
  };
}
