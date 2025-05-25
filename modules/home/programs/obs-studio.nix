{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.obs-studio;
in
{
  options.deeznuts.programs.obs-studio = {
    enable = mkEnableOption "OBS Studio";
    hyprland.workspace = mkOption {
      type = types.int;
      default = 8;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(com\.obsproject\.Studio)$"
      ];
    };

    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-webkitgtk
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi

        # advanced-scene-switcher
        # obs-vertical-canvas
        obs-source-switcher
        # obs-source-record
        obs-source-clone
        obs-shaderfilter
        obs-move-transition
        obs-gradient-source
        # obs-command-source

        # obs-composite-blur
        # obs-transition-table
        # obs-backgroundremoval
      ];
    };
  };
}
