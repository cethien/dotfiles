{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.programs.spicetify;
in {
  config = {
    programs.spicetify = {
      spotifyPackage = pkgs-unstable.spotify;
      spicetifyPackage = pkgs-unstable.spicetify-cli;
      spotifywmPackage = pkgs-unstable.spotifywm;
      spotifyLaunchFlags = "--password-store=basic";
      enabledExtensions = with pkgs.spicePkgs.extensions; [
        adblockify
        hidePodcasts
        autoSkipVideo
        keyboardShortcut
      ];
      enabledCustomApps = with pkgs.spicePkgs.apps; [
        newReleases
        ncsVisualizer
        historyInSidebar
      ];
      enabledSnippets = with pkgs.spicePkgs.snippets; [
        pointer
        fixMainViewWidth
      ];
    };

    stylix.targets.spicetify.enable = false;

    wayland.windowManager.hyprland.extraLuaFiles."99-spotify" =
      lib.mkIf cfg.enable
      #lua
      ''
        hl.window_rule({
            match = { class = "^(Spotify)$", },
            workspace = hl.defaultWorkspace.spotify,
        })
      '';
  };
}
