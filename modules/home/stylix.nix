{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  cfg = config.stylix;
in {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  config = mkIf cfg.enable {
    home.pointerCursor.enable = true;
    home.file.".config/uwsm/env-hyprland".text = let
      c = config.stylix.cursor;
    in ''
      export HYPRCURSOR_THEME=${c.name}
      export HYPRCURSOR_SIZE=${toString c.size}
    '';

    stylix = {
      targets = {
        gtksourceview.enable = false;
      };

      polarity = "dark";
      base16Scheme = mkDefault "${pkgs-unstable.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      cursor = {
        size = mkDefault 26;
        package = pkgs-unstable.simp1e-cursors;
        name = "Simp1e-Tokyo-Night";
      };

      icons = {
        enable = true;
        package = pkgs-unstable.tela-icon-theme;
        dark = "Tela-dracula-dark";
        light = "Tela-dracula";
      };

      fonts = {
        sansSerif = {
          package = pkgs-unstable.nerd-fonts.noto;
          name = "NotoSans Nerd Font";
        };
        serif = {
          package = pkgs-unstable.nerd-fonts.noto;
          name = "NotoSerif Nerd Font";
        };

        monospace = {
          package = pkgs-unstable.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font";
        };

        emoji = {
          package = pkgs-unstable.noto-fonts-color-emoji;
          name = "Noto Color emoji";
        };

        sizes = {
          applications = mkDefault 14;
          terminal = mkDefault 14;
          desktop = mkDefault 16;
          popups = mkDefault 14;
        };
      };

      opacity = {
        applications = mkDefault 1.0;
        terminal = mkDefault 0.8;
        desktop = mkDefault 0.75;
        popups = mkDefault 0.9;
      };
    };
  };
}
