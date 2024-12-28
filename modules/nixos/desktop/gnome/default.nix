{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.gnome;
in
{
  options.deeznuts.desktop.gnome = {
    enable = mkEnableOption "Enable gnome desktop";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-photos
      gnome-music
      epiphany # web browser
      yelp # help
      seahorse # password manager
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks

      sushi # gnome file manager previewer
      decibels # gnome audio player
      drawing # gnome image editor
      video-trimmer # gnome video editor
      pika-backup # gnome backup tool
    ];

    programs.kdeconnect.enable = true;
    programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  };
}
