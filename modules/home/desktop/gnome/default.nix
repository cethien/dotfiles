{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.desktop.gnome;
in
{
  imports = [
    ./dconf-settings
    ./extensions
    ./keybindings
  ];

  options.deeznuts.desktop.gnome = {
    enable = mkEnableOption "Enable gnome desktop";
  };

  config = mkIf cfg.enable {
    programs.gnome-shell.enable = true;
  };
}
