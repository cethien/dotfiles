{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.obs-studio;
in
{
  options.deeznuts.programs.obs-studio = {
    enable = mkEnableOption "Enable OBS Studio";
  };

  config = mkIf cfg.enable {
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
