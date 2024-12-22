{ lib, config, ... }:

{
  imports = [
    ./dconf-settings
    ./extensions
    ./keybindings
  ];

  options.desktop-environment.gnome.enable = lib.mkEnableOption "Enable gnome desktop environment customization";

  config = lib.mkIf config.desktop-environment.gnome.enable {
    programs.gnome-shell.enable = true;
  };
}
