{
  pkgs,
  config,
  ...
}: let
  monitors = {
    lpt = "eDP-1";
    eizo = "desc:Eizo Nanao Corporation EV2430 33096078";
  };
in {
  imports = [
    ../../modules/home
    ../../homes/tms-bso/email.nix
    ../../homes/tms-bso/ssh.nix
    ../../homes/tms-bso/rdp.nix
    ../../homes/tms-bso/zen-browser.nix
  ];

  stylix.image = ../../wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = with monitors; {
      monitor = [
        "${eizo}, 1920x1200@60, 0x0, 1"
        "${lpt}, 1920x1080@60, 1920x0, 1"
      ];
      general.allow_tearing = true;

      workspace = [
        "1, monitor:${eizo}, persistent:true, default:true"
        "2, monitor:${eizo}, persistent:true"
        "3, monitor:${eizo}, persistent:true"
        "4, monitor:${eizo}, persistent:true"
        "5, monitor:${eizo}, persistent:true"

        "6, monitor:${lpt}, persistent:true, default:true"
        "7, monitor:${lpt}, persistent:true"
        "8, monitor:${lpt}, persistent:true"
      ];
    };

    autostart = [
      "keepassxc"
    ];
  };
  programs.hyprlock.monitor = "${monitors.lpt}";

  home.packages = with pkgs; [
    simple-scan
    libreoffice
    drawio
    rustdesk-flutter
    dbeaver-bin
    omnissa-horizon-client
  ];

  services.davmail.enable = true;

  programs = {
    slack.enable = true;
    thunderbird.enable = true;
    spotify.enable = true;
    keepassxc.enable = true;
    container-tools.enable = true;
    kitty.enable = true;
  };
}
