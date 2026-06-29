{
  config,
  lib,
  pkgs,
  ...
}: {
  # work

  imports = [
    ../_common/home/cethien
  ];

  stylix.image = ../_common/home/wallpapers/lake-mountains-rocks-sunrise-daylight-scenery-illustration-3840x2160-3773.jpg;

  wayland.windowManager.hyprland.extraLuaFiles = {
    "50-tower-of-power".content = ./hyprland-tower-of-power.lua;
  };
  programs.hyprlock.monitor = "desc:GWD ARZOPA 000000000001";

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
    # work
    slack.enable = true;
    freerdp.enable = true;
    freerdp.connections = import ../_tms/home/rdp.nix;

    # ---

    rclone.enable = true;

    rofi.powermenu.options = "shutdown/reboot";

    zen-browser = import ./zen-browser.nix {inherit config pkgs;};
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

    git.settings = (import ../_common/home/git.nix) // (import ../_tms/home/git.nix);
    ssh.settings = (import ../_common/home/ssh.nix) // (import ../_tms/home/ssh.nix);
  };
}
