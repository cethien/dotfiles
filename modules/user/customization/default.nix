{ system, ... }:

{
  imports = [ 
    ./gnome.nix
    ./wallpaper.nix
  ];

  catppuccin.enable = true;

  user.customization.gnome.enable = !system.profile.isWSL;
}