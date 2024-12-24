{ lib, config, ... }:

{
  imports = [
    ./dconf-settings
    ./extensions
    ./keybindings
  ];

  options.deeznuts.desktop.gnome.enable = lib.mkEnableOption "Enable gnome desktop environment customization";

  config = lib.mkIf config.deeznuts.desktop.gnome.enable {
    programs.gnome-shell.enable = true;
  };
}
