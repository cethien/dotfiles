{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/home
    ../../modules/home/users/cethien
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
  };

  home.packages = with pkgs; [simple-scan ausweisapp libreoffice];

  services.syncthing.enable = true;
  services.restic.enable = true;
  programs.rclone.enable = true;

  programs = {
    ssh.matchBlocksExtra =
      (import ../../homes/bso-lenovo/ssh.nix)
      // import ../../homes/ssh.nix;
    freerdp.enable = true;
    browser.firefox-profile.containers = ["tmsproshop.de" "tmsproshop.de/admin"];

    freerdp.connections = import ../../homes/bso-lenovo/rdp.nix;

    kitty.enable = true;
    zen-browser.enable = true;
    browser.default = config.programs.zen-browser.package;
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
