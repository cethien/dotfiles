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
    home.packages = with pkgs; [
      xrandr
      libnotify
      playerctl
      brightnessctl
      wl-clipboard
      gpu-screen-recorder
    ];

    programs = {
      kitty.enable = true;
      rofi.enable = true;
      mpv.enable = true;
      imv.enable = true;
      zathura.enable = true;
      fileroller.enable = true;
    };

    services = {
      mako.enable = true;
      battery-checker.enable = true;
      wpaperd.enable = true;
      hyprpaper.enable = lib.mkForce config.stylix.enable;
    };

    wayland.windowManager.hyprland = {
      # configType = "lua";
      settings = import ./hyprland-settings.nix {inherit pkgs;};
    };
  };
}
