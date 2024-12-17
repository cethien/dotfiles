{ lib, config, pkgs, ... }:

{
  options.user.desktop.theming.gtk.enable = lib.mkEnableOption "Enable gtk theming";

  config = lib.mkIf config.user.desktop.theming.gtk.enable {
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