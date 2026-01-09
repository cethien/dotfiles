{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.services.pipewire.active-mic = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Das exakte Mic-Device für ANC. Wenn null, wird kein ANC geladen.";
  };

  config = mkIf config.deeznuts.desktop.isEnabled {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;

      extraConfig.pipewire."99-input-denoising" = let
        mic = config.services.pipewire.active-mic;
      in {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "ANC (RNNoise)";
              "media.name" = "ANC (RNNoise)";
              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    label = "noise_suppressor_mono";
                    control = {"VAD Threshold (%)" = 70.0;};
                  }
                ];
              };
              "capture.props" = {
                "node.passive" = true;
                "node.target" = mic;
              };
              "playback.props" = {
                "media.class" = "Audio/Source";
                "node.name" = "rnnoise_source";
              };
            };
          }
          # --- DeepFilterNet Source ---
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "ANC (DeepFilter)";
              "media.name" = "ANC (DeepFilter)";
              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "deepfilter";
                    plugin = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                    label = "deep_filter_mono";
                  }
                ];
              };
              "capture.props" = {
                "node.passive" = true;
                "node.target" = mic;
              };
              "playback.props" = {
                "media.class" = "Audio/Source";
                "node.name" = "deepfilter_source";
              };
            };
          }
        ];
      };
    };
  };
}
