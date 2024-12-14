{ lib, config, pkgs, ... }:

{
  options.user.apps.obs-studio.enable = lib.mkEnableOption "Enable OBS Studio";

  config = lib.mkIf config.user.apps.obs-studio.enable {
    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-webkitgtk
        obs-vkcapture
        obs-pipewire-audio-capture

        advanced-scene-switcher
        obs-vertical-canvas
        obs-source-switcher
        obs-source-record
        obs-source-clone
        obs-shaderfilter
        obs-move-transition
        obs-gradient-source
        obs-composite-blur
        # obs-transition-table
      ];
    };
  };
}
