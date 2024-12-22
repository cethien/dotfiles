{ lib, config, pkgs, ... }:

{
  options.desktop.gnome.enable = lib.mkEnableOption "Enable GNOME Desktop";

  config = lib.mkIf config.desktop.gnome.enable {
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
