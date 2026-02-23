{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien

    ../../homes/tms-bso/ssh.nix
    ../../homes/tms-bso/rdp.nix
  ];

  stylix.image = ../../wallpapers/boy_and_cat_sitting_on_stairs.jpeg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "HDMI-A-1, 2560x1440@60, 0x0, 1"
        "eDP-1, 1920x1080@60, 320x1440, 1"
      ];

      workspace = [
        "1, monitor:eDP-1, persistent:true"
        "2, monitor:eDP-1, persistent:true"

        "3, monitor:HDMI-A-1, persistent:true"
        "4, monitor:HDMI-A-1, persistent:true"
        "5, monitor:HDMI-A-1, persistent:true"
      ];
    };

    autostart = [
      "keepassxc"
    ];

    defaultWorkspaces.browser = 2;
  };

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
      "tmsproshop.de" = {
        id = 3;
        color = "green";
        icon = "briefcase";
      };
      "tmsproshop.de/admin" = {
        id = 4;
        color = "purple";
        icon = "briefcase";
      };
    };

    spaces."on deez road again" = {
      id = "1d6bd4a3-319b-4782-b201-cfb3bd230a90";
      position = 1000;
      icon = "🚄";
    };

    pins = {
      "WhatsApp" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        url = "https://web.whatsapp.com/";
        isEssential = true;
        position = 101;
      };
      "Discord" = {
        id = "96070d37-4b78-490f-87d1-884474bd9434";
        url = "https://discord.com/channels/@me";
        isEssential = true;
        position = 102;
      };

      "YouTube" = {
        id = "8af62707-0722-4049-9801-bedced343333";
        url = "https://www.youtube.com/feed/subscriptions";
        position = 110;
      };
      "GitHub" = {
        id = "fb316d70-2b5e-4c46-bf42-f4e82d635153";
        url = "https://github.com/";
        position = 111;
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

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  programs = {
    ssh.matchBlocksExtra = import ../../homes/ssh.nix;

    kitty.enable = true;
    keepassxc.enable = true;
    gemini-cli.enable = true;

    devSuite.extras = ["containers"];

    creativeSuite = {
      enable = true;
      extras = ["mixxx"];
    };
    spotify.enable = true;
  };
}
