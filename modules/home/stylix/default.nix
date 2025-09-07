{
  lib,
  config,
  pkgs,
  stylix,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.stylix;
in {
  imports = [
    stylix.homeModules.stylix
  ];

  options.deeznuts.stylix = {
    enable = mkEnableOption "Enable theming with stylix";

    sizes = {
      cursor = mkOption {
        type = types.int;
        default = 26;
      };
      applications = mkOption {
        type = types.int;
        default = 13;
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
        default = 12;
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: remove when https://github.com/nix-community/stylix/issues/478 is resolved
    wayland.windowManager.hyprland.settings = {
      env = [
        "HYPRCURSOR_THEME,${toString config.stylix.cursor.name}"
        "HYPRCURSOR_SIZE,${toString config.stylix.cursor.size}"
      ];
    };

    stylix = {
      enable = true;

      image = ./wallpapers/a_hand_holding_a_cassette_tape.jpg;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

      cursor = {
        size = cfg.sizes.cursor;
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
