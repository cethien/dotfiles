{
  config,
  lib,
  pkgs,
  ...
}: let
  monitors = {
    self = "eDP-1";
    eizo = "desc:Eizo Nanao Corporation EV2430 33096078";
  };
in {
  imports = [
    ./home
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland = import ./hyprland-settings.nix {
    inherit lib monitors;
    hLib = config.lib.deeznuts.hyprland;
  };
  programs.hyprlock.monitor = "${monitors.self}";

  home.packages = with pkgs; [
    simple-scan
    drawio
    rustdesk-flutter
    dbeaver-bin
    winboat
  ];

  services.davmail.enable = true;

  programs = {
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = true;
    libreoffice.enable = true;
    keepassxc.enable = true;
    keepassxc.hyprlandAutostart = true;

    git.settings = import ./home/git.nix;
    ssh.settings = import ./home/ssh.nix // {"Host *".IdentityFile = "~/.ssh/id_ed25519";};
    freerdp.enable = true;
    freerdp.connections = import ./home/rdp.nix;
  };
}
