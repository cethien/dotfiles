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
    ../../modules/home
    ../../modules/home/users/cethien
    ./zen-browser.nix
  ];

  stylix.image = ../../wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = with monitors; [
        "${asus}, 2560x1440@240, 0x0, 1, bitdepth,10"
        "${arzopa}, 1920x1080@100, 640x1440, 1"
      ];
      general.allow_tearing = true;
      exec-once = ["xrandr --output DP-1 --primary"];

      workspace = with monitors; [
        "4, monitor:${arzopa}, persistent:true, default:true, layout:master"
        "5, monitor:${arzopa}, persistent:true"

        "1, monitor:${asus}, persistent:true, default:true, layout:master"
        "2, monitor:${asus}, persistent:true"
        "3, monitor:${asus}, persistent:true"
      ];
    };
    defaultWorkspaces = {
      gaming = 10;
      browser = 4;
    };

    autostart = [
      "logitech"
      "steam"
    ];
  };
  programs.hyprlock.monitor = "${monitors.asus}";

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice krita ardour];

  programs = {
    spotify.enable = true;
    nixcord.enable = true;

    thunderbird.enable = true;

    obs-studio.enable = true;
    pokemmo.enable = true;
    retroarch.enable = true;
    prismlauncher.enable = true;
    r2modman.enable = true;
    steam.enable = true;

    container-tools.enable = true;
    keepassxc.enable = true;
    kitty.enable = true;
    ssh.matchBlocksExtra = import ../../homes/ssh.nix;
    git.urlExtra = {
      "ssh://git@git.cethien.home".insteadOf = "https://git.cethien.home";
      "git@git.cethien.home:".insteadOf = "home:";
    };
  };
  programs.logitech-peripherals.enable = true;
}
