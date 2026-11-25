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
    ../_tms/home/tailscale.nix
  ];

  stylix.image = ../_common/home/wallpapers/bliss_4K.jpg;
  wayland.windowManager.hyprland.extraLuaFiles = {
    "50-tms-bso".content = ./hyprland-tms-bso.lua;
  };

  programs.hyprlock.monitor = "eDP-1";

  home.packages = with pkgs; [
    # winboat
    nextcloud-client
    nextcloud-talk-desktop
    rustdesk
  ];

  services.davmail.enable = true;

  programs = {
    dbeaver.enable = true;
    slack.enable = true;
    slack.autostart = true;
    thunderbird.enable = true;
    thunderbird.autostart = false;
    libreoffice.enable = true;

    zen-browser = import ./home/zen-browser.nix {inherit config pkgs;};
    rbw.enable = true;

    aerc = {
      enable = true;
      extraConfig = {
        general."unsafe-accounts-conf" = true;
        ui."mouse-enabled" = true;
        viewer = {
          alternatives = "text/plain,text/html";
          "html-inline-images" = true;
        };
        filters = {
          "text/plain" = "colorize";
          "text/html" = "w3m -T text/html -I UTF-8 -dump -o display_link_number=1 | colorize";
        };
        openers."text/html" = "xdg-open";
        compose.editor = "nvim";
        "multipart-converters"."text/html" = "pandoc -f gfm -t html --standalone";
      };
      extraBinds = {
        "compose::review" = {
          "H" = ":multipart text/html<Enter>";
        };
        messages = {
          "j" = ":next<Enter>";
          "k" = ":prev<Enter>";
          "<Down>" = ":next<Enter>";
          "<Up>" = ":prev<Enter>";
          "Enter" = ":view<Enter>";
          "q" = ":quit<Enter>";
        };
        view = {
          "o" = ":open<Enter>";
          "O" = ":open-link<Enter>";
        };
      };
    };
    rbw.settings = import ../_tms/home/bitwarden.nix;

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
