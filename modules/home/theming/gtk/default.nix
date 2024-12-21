{ lib, config, pkgs, ... }:

{
  options.theming.gtk.enable = lib.mkEnableOption "Enable gtk theming";

  config = lib.mkIf config.theming.gtk.enable {
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
