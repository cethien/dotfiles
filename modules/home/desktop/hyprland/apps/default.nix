{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./hyprpaper.nix
    # ./waybar
    ./hyprpanel.nix
    ./rofi.nix
    ./wlogout.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpicker
      hyprshot
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "steam -silent"
        "solaar -w hide"
      ];

      "$terminal" = "kitty";
      "$fileManager" = "kitty yazi";
      "$menu" = "rofi -show drun";

      bind = [
        "$mainMod, R, exec, $menu"
        "$mainMod, SPACE, exec, $menu"

        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $fileManager"

        "$mainMod SHIFT, C, exec, hyprpicker -a"

        "$mainMod SHIFT, S, exec, hyprshot -m region"
        ", Print, exec, hyprshot -m window"
      ];
    };
  };
}
