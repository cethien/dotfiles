{ pkgs,... }:
{
  catppuccin.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
  };

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome-music
    gnome-text-editor
    epiphany # web browser
    yelp # help
    seahorse # password manager
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks

    sushi # gnome file manager previewer
    decibels # gnome audio player
    video-trimmer # gnome video editor
    pika-backup # gnome backup tool
    drawing # gnome image editor

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
