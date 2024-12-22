{ lib, config, ... }:

{
  imports = [
    ./dconf-settings
    ./extensions
    ./keybindings
  ];

  options.desktop.gnome.enable = lib.mkEnableOption "Enable gnome desktop environment customization";

  config = lib.mkIf config.desktop.gnome.enable {
    programs.gnome-shell.enable = true;
  };
}
