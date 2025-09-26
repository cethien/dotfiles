{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem mkEnableOption mkOption types mkMerge;
  cfg = config.programs.creativeSuite;
in {
  options.programs.creativeSuite = {
    enable = mkEnableOption "enable all media creation tools";
    extras = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = let
    mixxx = elem "mixxx" cfg.extras;
    ardour = elem "ardour" cfg.extras;
    obs = elem "obs-studio" cfg.extras;
  in
    mkIf cfg.enable {
      home.packages = mkMerge [
        (with pkgs; [pinta gimp inkscape ocenaudio])
        (mkIf mixxx [pkgs.mixxx])
        (mkIf ardour [pkgs.ardour])
      ];

      programs.obs-studio = {
        enable = obs;

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
