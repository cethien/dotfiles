{
  lib,
  config,
  pkgs,
  stylix,
  ...
}:
with lib; let
  cfg = config.stylix;
in {
  imports = [
    stylix.homeModules.stylix
  ];

  config = mkIf cfg.enable {
    # TODO: remove when https://github.com/nix-community/stylix/issues/478 is resolved
    wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME,${toString config.stylix.cursor.name}"
        "HYPRCURSOR_SIZE,${toString config.stylix.cursor.size}"
      ];
    };

    stylix = {
      # image = mkDefault ../../../wallpapers/blueish_river_landscape.jpg;
      polarity = "dark";
      base16Scheme = mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      cursor = {
        size = mkDefault 26;
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Tokyo-Night";
      };

      iconTheme = {
        enable = true;
        package = pkgs.tela-icon-theme;
        dark = "Tela-dracula-dark";
        light = "Tela-dracula";
      };

      fonts = {
        sansSerif = {
          package = pkgs.nerd-fonts.noto;
          name = "NotoSans Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.noto;
          name = "NotoSerif Nerd Font";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color emoji";
        };

        sizes = {
          applications = mkDefault 14;
          terminal = mkDefault 14;
          desktop = mkDefault 16;
          popups = mkDefault 16;
        };
      };

      opacity = {
        applications = mkDefault 1.0;
        terminal = mkDefault 0.90;
        desktop = mkDefault 0.75;
        popups = mkDefault 0.5;
      };
    };
  };
}
