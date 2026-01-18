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

  stylix.image = ../../wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 320x1440, 1"
      ];
      general.allow_tearing = true;
      exec-once = [''xrandr --output "DP-1" --primary''];

      workspace = [
        "1, monitor:DP-1, persistent:true"
        "2, monitor:DP-1, persistent:true"
        "3, monitor:DP-1, persistent:true"

        "4, monitor:HDMI-A-1, persistent:true"
        "5, monitor:HDMI-A-1, persistent:true"
      ];

      windowrule = [
        "match:class discord, workspace 5"
        "match:class steam, match:title ^(Friends List)$, workspace 5"
      ];
    };
    defaultWorkspaces = {
      browser = 4;
      gaming = 2;
    };

    autostart = [
      "logitech"
      "keepassxc"
      "spotify"
      "discord"
      "steam"
    ];
  };
  programs.hyprlock.monitor = "DP-1";

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice];

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

    devSuite.extras = ["containers"];

    creativeSuite = {
      enable = true;
    };
    spotify.enable = true;
    discord.enable = true;

    steam.enable = true;
    r2modman.enable = true;
    prismlauncher.enable = true;
    retroarch.enable = true;
    pokemmo.enable = true;
  };
  programs.logitech-peripherals.enable = true;
}
