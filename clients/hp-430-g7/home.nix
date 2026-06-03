{
  pkgs,
  config,
  ...
}: let
  monitors = {
    self = "eDP-1";
    asus = "desc:ASUSTek COMPUTER INC VG27AQML1A S9LMQS167913";
    arzopa = "desc:GWD ARZOPA 000000000001";
    eizo = "desc:Eizo Nanao Corporation EV2430 33096078";
  };
in {
  imports = [
    ../_common/home/cethien
  ];

  stylix.image = ../_common/home/wallpapers/boy_and_cat_sitting_on_stairs.jpeg;
  wayland.windowManager.hyprland = {
    settings = {
      monitor = with monitors; [
        "${asus}, 2560x1440@60, 0x0, 1"
        "${self}, 1920x1080@60, 320x1440, 1"
      ];

      workspace = with monitors; [
        "1, monitor:${self}, persistent:true, layout:master"
        "2, monitor:${self} persistent:true, default:true, layout:master"

        "3, monitor:${asus}, persistent:true"
        "4, monitor:${asus}, persistent:true"
        "5, monitor:${asus}, persistent:true"
      ];
    };

    rofiPowerMenuOptions = "shutdown/suspend/reboot";
    defaultWorkspaces.browser = 1;
  };

  home.packages = with pkgs; [simple-scan ausweisapp mixxx qlcplus];

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

  programs = {
    rclone.enable = true;

    zen-browser.enable = true;
    freerdp.enable = true;
    freerdp.connections = import ../tms-bso/home/rdp.nix;
    ssh.settings =
      (import ../_common/home/ssh.nix)
      // {
        "Match host 10.*" = {
          User = "bsotnikow";
          IdentityFile = "~/.ssh/id_ed25519_tmsproshop_bsotnikow";
        };
      }
      // (import ../tms-bso/home/ssh.nix);
  };
}
