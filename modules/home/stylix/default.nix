{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.stylix;
in
{
  options.deeznuts.stylix = {
    enable = mkEnableOption "Enable theming with stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      image = ./wallpapers/pixelart-mountains.png;

      cursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 24;
      };

      iconTheme = {
        enable = true;
        package = pkgs.tela-icon-theme;
        dark = "Tela-dracula-dark";
        light = "Tela-dracula";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.meslo-lg;
          name = "MesloLG Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.open-sans;
          name = "Open Sans";
        };
        serif = {
          package = pkgs.roboto;
          name = "Roboto Serif";
        };

        emoji = {
          package = pkgs.openmoji-color;
          name = "OpenMoji Color";
        };

        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 16;
          popups = 10;
        };
      };

      opacity = {
        applications = 1.0;
        terminal = 1.0;
        desktop = 1.0;
        popups = 1.0;
      };

      targets = {
        vscode.enable = false;
        mangohud.enable = false;
      };
    };
  };
}
