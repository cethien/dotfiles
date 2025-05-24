{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.stylix;
in {
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
    stylix.targets = {
      nvf.enable = false;

      vscode.enable = false;
      mangohud.enable = false;
      spicetify.enable = false;
      rofi.enable = false;
      mako.enable = false; # i dont use but fix for https://github.com/nix-community/home-manager/issues/6971
    };

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      image = ./wallpapers/a_hand_holding_a_cassette_tape.jpg;

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
        terminal = 0.90;
        desktop = 0.75;
        popups = 0.5;
      };
    };
  };
}
