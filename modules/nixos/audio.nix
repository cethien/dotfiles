{
  lib,
  config,
  pkgs,
  nix-gaming,
  musnix,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.services.pipewire.active-mic = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "mic device for anc. null = nothing";
  };

  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
    musnix.nixosModules.musnix
  ];

  config = mkIf config.deeznuts.desktop.isEnabled {
    musnix.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };

      wireplumber.enable = true;

      extraLadspaPackages = with pkgs; [
        rnnoise-plugin
        deepfilternet
        tap-plugins
      ];

      extraConfig.pipewire = let
        mic = config.services.pipewire.active-mic;
      in
        lib.mkIf (mic != null) {
          "150-mic-filter"."context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Microphone (Filtered)";
                "media.name" = "Microphone (Filtered)";
                "filter.graph" = {
                  links = [
                    {
                      output = "rnnoise:Output";
                      input = "deesser:Input";
                    }
                  ];
                  nodes = [
                    {
                      type = "ladspa";
                      name = "rnnoise";
                      plugin = "librnnoise_ladspa";
                      label = "noise_suppressor_mono";
                      control = {
                        "VAD Threshold (%)" = 20.0;
                        # "Release time (ms)" = 200;
                      };
                    }
                    {
                      type = "ladspa";
                      name = "deesser";
                      plugin = "tap_deesser";
                      label = "tap_deesser";
                      control = {
                        "Threshold Level [dB]" = -20.0;
                        "Frequency [Hz]" = 3400.0;
                      };
                    }
                  ];
                };
                "audio.position" = ["MONO"];
                "capture.props" = {
                  "node.passive" = true;
                  "node.target" = mic;
                };
                "playback.props" = {
                  "media.class" = "Audio/Source";
                  "node.name" = "mic_source";
                };
              };
            }
          ];
        };
    };
  };
}
