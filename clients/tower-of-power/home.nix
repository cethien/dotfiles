{
  stateVersion,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
  ];

  home.stateVersion = stateVersion;
  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  stylix.image = ../../wallpapers/triangular-5120x2880-19678.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 320x1440, 1"
      ];
      general.allow_tearing = true;
      exec-once = ["${pkgs.xorg.xrandr} --output DP-1 --primary"];

      workspace = [
        "1, monitor:HDMI-A-1, persistent:true" # browser
        "2, monitor:DP-1, persistent:true" # general
        "3, monitor:DP-1, persistent:true" # general
        "4, monitor:DP-1, persistent:true" # general

        "5, monitor:HDMI-A-1, persistent:true"
        "6, monitor:HDMI-A-1, persistent:true"
      ];
    };
    defaultWorkspaces = {
      browser = 1;
      gaming = 4;
    };

    autostart = [
      "chromium"
      "keepassxc"
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
    discord.enable = true;
  };

  deeznuts.gaming = [
    "steam"
    "r2modman"
    "minecraft"
    "retroarch"
    "pokemmo"
  ];
}
