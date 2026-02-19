{
  pkgs,
  config,
  ...
}: let
  monIn = "eDP-1";
  monEx = "desc:Eizo Nanao Corporation EV2430 33096078";
in {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
    ./smb.nix
  ];

  stylix.image = ../../wallpapers/bliss-windows-night-nologo-8k-unofficial.png;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "${monEx}, 1920x1200@60, 0x0, 1"
        "${monIn}, 1920x1080@60, 480x1200, 1"
      ];
      general.allow_tearing = true;


      workspace = [
        "1, monitor:${monEx}, persistent:true"
        "2, monitor:${monEx}, persistent:true"
        "3, monitor:${monEx}, persistent:true"

        "4, monitor:${monIn}, persistent:true"
        "5, monitor:${monIn}, persistent:true"
        "6, monitor:${monIn}, persistent:true"
      ];
    };

    autostart = [
      "keepassxc"
      "slack"
      "zen"
    ];

    defaultWorkspaces = {
      browser = 4;
      chat = 5;
    };
  };
  programs.hyprlock.monitor = "${monIn}";

  home.packages = with pkgs; [
    simple-scan
    libreoffice

    rustdesk-flutter
  ];

  xdg.desktopEntries.outlook = {
    name = "Outlook (web)";
    icon = "outlook";
    exec = "${pkgs.chromium}/bin/chromium --app=https://outlook.tmsproshop.de/";
  };

  programs = {
    ssh.matchBlocksExtra = import ../../homes/bso-lenovo/ssh.nix;
    slack.enable = true;
    freerdp.enable = true;
    freerdp.connections = import ../../homes/bso-lenovo/rdp.nix;

    kitty.enable = true;
    chromium.enable = true;
    keepassxc.enable = true;
    gemini-cli.enable = true;

    devSuite.extras = ["containers"];

    spotify.enable = true;
  };
}
