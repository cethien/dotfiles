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
    ./rofi.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprshot.nix
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
    # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
    wayland.windowManager.hyprland.systemd.enable = false;

    home.packages = with pkgs; [
      xrandr
      libnotify
      playerctl
      brightnessctl
      wl-clipboard
      gpu-screen-recorder
    ];

    services.hyprpaper.enable = lib.mkForce false; # due to stylix which enables
    services.wpaperd.enable = true;
    services.mako.enable = true;
    programs.rofi.enable = true;
    services.battery-checker.enable = true;

    wayland.windowManager.hyprland = {
      # configType = "lua";

      settings =
        import ./hyprland-settings.nix {inherit pkgs;}
        // {
          exec-once = [
            "${pkgs.udiskie}/bin/udiskie"
          ];
        };
    };
  };
}
