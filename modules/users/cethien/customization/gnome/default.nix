{ lib, config, ...}: 

{
  imports = [ ./extensions.nix ./keybindings.nix ./dconf-settings.nix ./theming.nix ];

  options.user.customization.gnome.enable = lib.mkEnableOption "Enable gnome customization";

  config = lib.mkIf config.user.customization.gnome.enable {
    user.customization.gnome.extensions.enable = true;
    user.customization.gnome.keybindings.enable = true;
    user.customization.gnome.dconf-settings.enable = true;
    user.customization.gnome.theming.enable = true;
  };  
}
