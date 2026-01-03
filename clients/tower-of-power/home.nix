{stateVersion, ...}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
  ];

  home.stateVersion = stateVersion;
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  stylix.image = ../../wallpapers/bliss_minimal.png;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 640x1440, 1"
      ];

      workspace = [
        "1, monitor:HDMI-A-1, persistent:true" # browser
        "2, monitor:DP-1, persistent:true" # general
        "3, monitor:DP-1, persistent:true" # general
        "4, monitor:DP-1, persistent:true" # general
        "5, monitor:DP-1, persistent:true" # general

        "6, monitor:HDMI-A-1, persistent:true" # video
        "7, monitor:HDMI-A-1, persistent:true" # spotify
        "8, monitor:HDMI-A-1" # btm
        "9, monitor:HDMI-A-1" # discord
        "10, monitor:HDMI-A-1" # obs
      ];
    };
    defaultWorkspaces = {
      browser = 1;
      gaming = 3;
    };

    autostart = [
      "keepassxc"
      "spotify"
      "discord"
    ];
  };

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  programs = {
    ssh.matchBlocksExtra = import ../../homes/ssh.nix;

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
    };
    spotify.enable = true;
    vesktop.enable = true;
  };

  deeznuts.gaming = [
    "r2modman"
    "minecraft"
    "retroarch"
    "pokemmo"
  ];
}
