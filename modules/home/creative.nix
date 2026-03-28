{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.creativeSuite;
in {
  options.programs.creativeSuite = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.desktop.isEnabled;
    };
  };

  config = {
    home.packages = lib.mkIf cfg.enable (with pkgs; [
      pinta
      gimp
      inkscape
      # ocenaudio
    ]);

    programs.obs-studio = {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-webkitgtk
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi

        advanced-scene-switcher
        # obs-vertical-canvas
        obs-source-switcher
        obs-source-record
        obs-source-clone
        obs-shaderfilter
        obs-move-transition
        obs-gradient-source
        obs-command-source

        obs-composite-blur
        obs-transition-table
        obs-backgroundremoval
      ];
    };
  };
}
