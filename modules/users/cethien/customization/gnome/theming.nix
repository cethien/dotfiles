{ lib, config, pkgs, ... }:

{
  options.user.customization.gnome.theming.enable = lib.mkEnableOption "Enable gnome customization";

  config = lib.mkIf config.user.customization.gnome.theming.enable {
    
    gtk = {
      enable = true;

      catppuccin = {
        enable = true;
        gnomeShellTheme = true;

        tweaks = [ "rimless" ];
      };

      iconTheme = {
        name = "Tela-purple-dark";
        package = pkgs.tela-icon-theme;
      };

      cursorTheme = {
        name  = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
      };
    };

    qt = {
      enable = true;
      
      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

  };
}