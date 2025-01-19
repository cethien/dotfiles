{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.stylix;
in
{
  options.deeznuts.stylix = {
    enable = mkEnableOption "Enable theming with stylix";

    sizes = {
      cursor = mkOption {
        type = types.int;
        default = 18;
      };
      applications = mkOption {
        type = types.int;
        default = 12;
      };
      terminal = mkOption {
        type = types.int;
        default = 14;
      };
      desktop = mkOption {
        type = types.int;
        default = 16;
      };
      popups = mkOption {
        type = types.int;
        default = 10;
      };
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      image = ./wallpapers/minimalistic-space.jpg;

      cursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = cfg.sizes.cursor;
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
          applications = cfg.sizes.applications;
          terminal = cfg.sizes.terminal;
          desktop = cfg.sizes.desktop;
          popups = cfg.sizes.popups;
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
