{ system, ... }:

{
  imports = [ 
    ./gnome
    ./wallpaper.nix
  ];

  catppuccin.enable = true;

  user.customization.gnome.enable = !system.profile.isWSL;
}