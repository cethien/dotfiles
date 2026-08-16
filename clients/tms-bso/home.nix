{
  config,
  lib,
  pkgs,
  ...
}: let
  tmsSsh = import ../_tms/home/ssh.nix {};
in {
  imports = [
    ./home
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland.extraLuaFiles = {
    "50-tms-bso".content = ./hyprland-tms-bso.lua;
  };

  programs.hyprlock.monitor = "eDP-1";

  home.packages = with pkgs; [
    rustdesk-flutter
    # winboat
  ];

  services.davmail.enable = true;

  programs = {
    dbeaver.enable = true;
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;

    zen-browser = import ./zen-browser.nix {inherit config pkgs;};

    ssh.settings =
      tmsSsh.raw
      // {
        "Host *" = {
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    freerdp.enable = true;
    freerdp.connections = import ../_tms/home/rdp.nix;
  };
}
