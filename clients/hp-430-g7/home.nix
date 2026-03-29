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

    rofiPowerMenuOptions = "shutdown/suspend/reboot";
    defaultWorkspaces.browser = 2;
  };

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice mixxx];

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
    spotify.enable = true;

    container-tools.enable = true;
    keepassxc.enable = true;
    kitty.enable = true;
    ssh.matchBlocksExtra = import ../../homes/ssh.nix;
  };
}
