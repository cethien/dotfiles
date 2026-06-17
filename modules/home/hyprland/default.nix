{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault mkOption types;
  cfg = config.wayland.windowManager.hyprland;
in {
  imports = [
    ./lib.nix
    ./hyprland-modals.nix

    ./battery-checker.nix
    ./notify-info.nix
    ./rofi
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprshot.nix
    ./text-extract.nix
    ./mako.nix
  ];

  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = mkOption {
      type = types.attrsOf types.int;
      default = {};
      description = "named workspaces";
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        # xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["gtk"];
        };
        hyprland = {
          default = [
            "hyprland"
            # "termfilechooser"
            "gtk"
          ];
        };
      };
    };

    xdg.configFile = {
      "hypr/xdph.conf".text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';

      # "xdg-desktop-portal-termfilechooser/config".text = ''
      #   [filechooser]
      #   cmd=kitty --class "yazi-portal" -e yazi --chooser-file="$out"
      # '';
    };

    home.packages = with pkgs; [
      xrandr
      libnotify
      playerctl
      brightnessctl
      wl-clipboard
    ];

    programs = {
      hyprlock.enable = true;

      kitty.enable = true;
      rofi.enable = true;
      mpv.enable = true;
      imv.enable = true;
      zathura.enable = true;
      fileroller.enable = true;
      hyprshot.enable = true;
      text-extract.enable = true;
    };

    services = {
      mako.enable = true;
      battery-checker.enable = true;
      wpaperd.enable = true;
      hyprpaper.enable = lib.mkForce config.stylix.enable;
    };

    wayland.windowManager.hyprland = {
      configType = "lua";
      settings = import ./hyprland-settings.nix {hlLib = config.lib.deeznuts.hyprland;};
    };
  };
}
