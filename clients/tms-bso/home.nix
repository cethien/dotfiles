{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland.extraLuaFiles = {
    "50-tms-bso".content = ./hyprland-tms-bso.lua;
  };

  programs.hyprlock.monitor = "eDP-1";

  home.packages = with pkgs; [
    simple-scan
    drawio
    rustdesk-flutter
    winboat
  ];

  services.davmail.enable = true;

  programs = {
    dbeaver.enable = true;
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;
    keepassxc.enable = true;
    keepassxc.autostart = true;

    git.settings = import ./home/git.nix;
    ssh.settings = import ./home/ssh.nix // {"Host *".IdentityFile = "~/.ssh/id_ed25519";};
    freerdp.enable = true;
    freerdp.connections = import ./home/rdp.nix;
  };
}
