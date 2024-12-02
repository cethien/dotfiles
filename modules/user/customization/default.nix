{ system, ... }:

{
  imports = [ ./gnome.nix ];

  catppuccin.enable = true;

  user.customization.gnome.enable = !system.profile.isWSL;
}