{
  pkgs,
  config,
  ...
}: let
  monitors = {
    asus = "desc:ASUSTek COMPUTER INC VG27AQML1A S9LMQS167913";
    arzopa = "desc:GWD ARZOPA 000000000001";
  };
in {
  imports = [
    ../_common/home/cethien
  ];

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
      "whatsapp" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        url = "https://web.whatsapp.com/";
        isEssential = true;
        position = 101;
      };
      "calendar" = {
        id = "591c45e0-737f-47d1-86e8-bf173ce87df9";
        url = "https://calendar.google.com";
        isEssential = true;
        position = 102;
      };

      "youtube" = {
        id = "217cf342-d929-419b-9a41-75ed87239d99";
        url = "https://www.youtube.com/feed/subscriptions";
        position = 1001;
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

  stylix.image = ../_common/home/wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;

  wayland.windowManager.hyprland = {
    settings = {
      monitor = with monitors; [
        "${asus}, 2560x1440@240, 0x0, 1, bitdepth,10, vrr,2"
        "${arzopa}, 1920x1080@100, 320x1440, 1"
      ];
      general.allow_tearing = true;
      exec-once = ["xrandr --output DP-1 --primary"];

      workspace = with monitors; [
        "4, monitor:${arzopa}, persistent:true, default:true, layout:master"
        "5, monitor:${arzopa}, persistent:true"

        "1, monitor:${asus}, persistent:true, default:true, layout:master"
        "2, monitor:${asus}, persistent:true"
        "3, monitor:${asus}, persistent:true"
        "10, monitor:${asus}"
      ];
    };
    defaultWorkspaces = {
      gaming = 10;
      browser = 4;
    };
  };
  programs.hyprlock.monitor = "${monitors.asus}";

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    simple-scan
    ausweisapp

    krita
    ardour
    mixxx
    qlcplus
  ];

  programs = {
    rclone.enable = true;

    spicetify.enable = true;
    nixcord.enable = true;
    nixcord.autostart = true;

    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;

    obs-studio.enable = true;
    pokemmo.enable = true;
    retroarch.enable = true;
    prismlauncher.enable = true;
    r2modman.enable = true;
    heroic.enable = true;
    steam.autostart = true;
    logitech-peripherals.enable = true;
    logitech-peripherals.autostart = true;
    apps-creative.enable = true;

    container-tools.enable = true;
    ssh.settings = import ../_common/home/ssh.nix;
    git.settings.url = {
      "git@git.cethien.home:".insteadOf = "home:";
    };
  };
}
