{ pkgs, ... }:
{
  catppuccin.enable = true;

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

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

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  fonts.packages = with pkgs; [
    roboto
    open-sans

    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.code-new-roman
  ];
}
