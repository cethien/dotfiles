{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkDefault;
  cfg = config.deeznuts.programs.hyprland;
  enabled = cfg.enable;
in
{
  imports = [
    ./kitty.nix
    ./wezterm.nix
    ./waybar
    ./rofi
    ./clipse.nix
    ./common-gui
    ./zathura.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpanel
    ./hyprshot
    ./wf-recorder
  ];

  config = mkIf enabled {
    home.packages = with pkgs; [
      brightnessctl
      hyprpicker
      udiskie
      playerctl
    ];

    deeznuts.programs = {
      hyprpaper.enable = mkDefault true;
      hyprpanel.enable = mkDefault true;
      # waybar.enable = mkDefault true;

      kitty.enable = mkDefault true;
      # wezterm.enable = mkDefault true;
      rofi.enable = mkDefault true;

      clipse.enable = mkDefault true;
      common-gui.enable = mkDefault true;
      zathura.enable = mkDefault true;
      wf-recorder.enable = mkDefault true;
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "solaar -w hide"
        "streamcontroller -b"
        "udiskie"
      ];

      bind = [
        "SUPER SHIFT, C, exec, hyprpicker -a"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
    };
  };
}
