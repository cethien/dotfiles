{ lib, config, pkgs, ... }:

{
  options.desktop.theming.gtk.enable = lib.mkEnableOption "Enable gtk theming";

  config = lib.mkIf config.desktop.theming.gtk.enable {
    gtk = {
      enable = true;

      catppuccin = {
        enable = true;
        gnomeShellTheme = true;

        tweaks = [ "rimless" ];
      };

      iconTheme = {
        name = "Tela-dracula-dark";
        package = pkgs.tela-icon-theme;
      };

      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
      };
    };
  };
}
