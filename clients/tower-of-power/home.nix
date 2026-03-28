{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
  ];

  stylix.image = ../../wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 320x1440, 1"
      ];
      general.allow_tearing = true;
      exec-once = ["xrandr --output DP-1 --primary"];

      workspace = [
        "1, monitor:DP-1, persistent:true"
        "2, monitor:DP-1, persistent:true"
        "3, monitor:DP-1, persistent:true"

        "4, monitor:HDMI-A-1, persistent:true"
        "5, monitor:HDMI-A-1, persistent:true"
      ];
    };
    defaultWorkspaces = {
      gaming = 2;
      browser = 4;
    };

    autostart = [
      "logitech"
      "keepassxc"
      "spotify"
      "steam"
    ];
  };
  programs.hyprlock.monitor = "DP-1";

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice];

  programs.zen-browser.enable = true;
  programs.browser.default = config.programs.zen-browser.package;
  programs.zen-browser.profiles."${config.home.username}" = let
    containers = {
      logged-out = {
        id = 1;
        color = "toolbar";
        icon = "chill";
      };
      admin = {
        id = 2;
        color = "pink";
        icon = "circle";
      };
    };

    spaces."deez nuts" = {
      id = "cd0b7a9b-bb11-42e8-a10a-52ea6813e6b4";
      position = 1000;
      icon = "🥙";
    };

    pins = {
      "WhatsApp" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        url = "https://web.whatsapp.com/";
        isEssential = true;
        position = 101;
      };
      "Google Calendar" = {
        id = "591c45e0-737f-47d1-86e8-bf173ce87df9";
        url = "https://calendar.google.com";
        isEssential = true;
        position = 102;
      };
    };
  in {
    containersForce = true;
    inherit containers;
    pinsForce = true;
    inherit pins;
    spacesForce = true;
    inherit spaces;
  };

  programs = {
    ssh.matchBlocksExtra = import ../../homes/ssh.nix;

    git.urlExtra = {
      "ssh://git@git.cethien.home".insteadOf = "https://git.cethien.home";
      "git@git.cethien.home:".insteadOf = "home:";
    };

    kitty.enable = true;
    keepassxc.enable = true;

    devSuite.extras = ["containers"];

    spotify.enable = true;
    vesktop.enable = true;

    steam.enable = true;
    r2modman.enable = true;
    prismlauncher.enable = true;
    retroarch.enable = true;
    pokemmo.enable = true;
  };
  programs.logitech-peripherals.enable = true;
}
