{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.spicetify;
in {
  config = {
    programs.spicetify = {
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
      # theme = pkgs.spicePkgs.themes.text;
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

        -- local pl = "${pkgs.playerctl}/bin/playerctl --player=spotify "
        --
        -- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(pl .. "play-pause"), { locked = true })
        -- hl.bind("XF86AudioNext", hl.dsp.exec_cmd(pl .. "next"), { locked = true })
        -- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(pl .. "previous"), { locked = true })
        --
        -- hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(pl .. "volume 0.05+"), { locked = true })
        -- hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(pl .. "volume 0.05-"), { locked = true })
      '';
  };
}
