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
    ../../homes/tms-bso/smb.nix
    ../../homes/tms-bso/email.nix
    ../../homes/tms-bso/ssh.nix
    ../../homes/tms-bso/rdp.nix
    ../../homes/tms-bso/zen-browser.nix
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
      chat = 3;
    };
  };
  programs.hyprlock.monitor = "${monIn}";

  home.packages = with pkgs; [
    simple-scan
    libreoffice

    rustdesk-flutter
  ];

  programs = {
    slack.enable = true;

    kitty.enable = true;
    # thunderbird.enable = true;
    keepassxc.enable = true;
    gemini-cli.enable = true;

    devSuite.extras = ["containers"];
    creativeSuite.enable = true;

    spotify.enable = true;
  };
}
