{pkgs, ...}: {
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
        "DP-1, 1920x1080@60, 0x0, 1"
        "eDP-1, 1920x1080@60, 340x1440, 1"
      ];
      general.allow_tearing = true;

      exec-once = ["[silent] slack -u"];
      workspace = [
        "1, monitor:DP-1, persistent:true"
        "2, monitor:DP-1, persistent:true"
        "3, monitor:DP-1, persistent:true"

        "4, monitor:eDP-1, persistent:true"
        "5, monitor:eDP-1, persistent:true"
        "6, monitor:eDP-1, persistent:true"
      ];
    };

    autostart = [
      "keepassxc"
    ];
  };
  programs.hyprlock.monitor = "DP-1";
  home.packages = with pkgs; [
    simple-scan
    libreoffice

    slack
    rustdesk-flutter
  ];

  xdg.desktopEntries.outlook = {
    name = "Outlook (web)";
    icon = "outlook";
    exec = "${pkgs.chromium}/bin/chromium --app=https://outlook.tmsproshop.de/";
  };

  programs = {
    ssh.matchBlocksExtra = import ../../homes/bso-lenovo/ssh.nix;
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
