{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.obs-studio = {
    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
      obs-pipewire-audio-capture

      # Automation & Logic
      advanced-scene-switcher
      obs-source-switcher
      obs-source-record
      obs-source-clone
      obs-command-source
      obs-transition-table
      obs-scene-as-transition
      obs-replay-source

      # Visual Effects
      obs-shaderfilter
      obs-move-transition
      obs-gradient-source
      obs-composite-blur
      obs-stroke-glow-shadow
      obs-backgroundremoval
      obs-retro-effects
      obs-rgb-levels
      obs-noise
      obs-3d-effect
      obs-advanced-masks
    ];
  };
}
