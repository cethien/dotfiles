{
  config,
  lib,
  pkgs,
  ...
}: let
  monitors = {
    asus = "desc:ASUSTek COMPUTER INC VG27AQML1A S9LMQS167913";
    arzopa = "desc:GWD ARZOPA 000000000001";
  };
in {
  # work
  programs.slack.enable = true;

  imports = [
    ../_common/home/cethien
  ];

  stylix.image = ../_common/home/wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;

  wayland.windowManager.hyprland = import ./hyprland-settings.nix {
    inherit lib monitors;
    hLib = config.lib.deeznuts.hyprland;
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

    rofi.powermenu.options = "shutdown/reboot";

    zen-browser = import ./zen-browser-settings.nix {inherit config;};
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

    git.settings = import ../_common/home/git.nix;
    ssh.settings = import ../_common/home/ssh.nix;
  };
}
