{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
      playerctl
    ];

    wayland.windowManager.hyprland = {
      settings = {
        # https://wiki.hyprland.org/Configuring/Keywords/
        "$mainMod" = "SUPER"; # windows key

        bind = [
          "$mainMod, M, exit"

          "ALT, F4, killactive"
          "$mainMod, C, killactive"

          "$mainMod, V, togglefloating"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        "$spotifyctl" = "playerctl --player=spotify";

        bindl = [
          ", XF86AudioRaiseVolume, exec, $spotifyctl volume 0.05+"
          ", XF86AudioLowerVolume, exec, $spotifyctl volume 0.05-"

          ", XF86AudioNext, exec, $spotifyctl next"
          ", XF86AudioPrev, exec, $spotifyctl previous"
          ", XF86AudioPlay, exec, $spotifyctl play-pause"
          ", XF86AudioPause, exec, $potifyctl play-pause"

          ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
      };
    };
  };
}
