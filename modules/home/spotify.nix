{
  lib,
  config,
  pkgs,
  spicetify-nix,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.spotify;
  as = builtins.elem "spotify" config.wayland.windowManager.hyprland.autostart;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.music;
in {
  options.programs.spotify.enable = mkEnableOption "spotify";

  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = {
      music = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = config.wayland.windowManager.hyprland.defaultWorkspaces.browser or null;
        description = "default music workspace";
      };
    };
  };

  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    programs.spicetify = let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        autoSkipVideo
        hidePodcasts
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        fixMainViewWidth
      ];
    };
    stylix.targets.spicetify.enable = false;

    programs.spotify-player = {
      enable = true;
      settings = {
        client_id = "9b20bf81c95d4710bee28bff24db41f9";
        enable_notify = false;
        device = {
          audio_cache = true;
          normalization = true;
        };
      };
    };
    programs.tmux.resurrectPluginProcesses = ["spotify_player"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["spotify_player -d"];
      windowrule = mkIf (!isNull ws) ["match:initial_class spotify_player, workspace ${toString ws}"];
      bind = [
        "SUPER SHIFT, M, exec, ${
          (pkgs.writeShellScriptBin "spotify-launch" ''
            set -e pipefail
            SESSION="spotify_player"
            if hyprctl clients | grep -q "class: $SESSION"; then
              hyprctl dispatch focuswindow "class:$SESSION"
              exit 0
            fi
            if ! tmux has-session -t "$SESSION" 2>/dev/null; then
              tmux new-session -d -s "$SESSION" "spotify_player"
              tmux new-session -d -s "$SESSION" "spotify_player && tmux kill-session -t $SESSION"
              tmux set-option -t "$SESSION" status off
            fi
            kitty --class "$SESSION" -e tmux attach-session -t "$SESSION"
          '')
        }/bin/spotify-launch"
      ];

      bindl = let
        # pl = "playerctl --player=spotify_player";
        pl = "spotify_player playback";
      in [
        ", XF86AudioPlay, exec, ${pl} play-pause"
        ", XF86AudioNext, exec, ${pl} next"
        ", XF86AudioPrev, exec, ${pl} previous"
        # ", XF86AudioRaiseVolume, exec, ${pl} volume 0.05+"
        # ", XF86AudioLowerVolume, exec, ${pl} volume 0.05-"
        ", XF86AudioRaiseVolume, exec, ${pl} volume --offset 5"
        ", XF86AudioLowerVolume, exec, ${pl} volume --offset -- -5"
      ];
    };

    programs.cava.enable = true;
    programs.cava.settings = {
      general = {
        framerate = 120;
        sensitivity = 33;
      };
      smoothing = {
        noise_reduction = 66;
        monstercat = 1;
        # waves = 1;
      };
      output = {
        reverse = 1;
      };
      color = {
        # background = "#000000";
        foreground = "#61AFEF";
      };
    };
  };
}
