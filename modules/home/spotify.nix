{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.spicetify;
in {
  options = {
    programs.spicetify.autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Ob Spotify beim Systemstart automatisch via XDG Autostart geladen werden soll.";
    };
  };

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
      theme = pkgs.spicePkgs.themes.text;
    };

    stylix.targets.spicetify.enable = false;

    xdg.configFile."autostart/spotify.desktop" = lib.mkIf (cfg.enable && cfg.autostart) {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=Spotify
        Exec=hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("spotify --password-store=basic", {workspace = "special:shadow_realm silent"}))'
        Icon=spotify
        Terminal=false
        Categories=AudioVideo;Player;
      '';
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-spotify" = let
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in
      lib.mkIf cfg.enable
      #lua
      ''
        hl.window_rule({
            match = {
                class = "^(Spotify)$",
            },
            workspace = hl.defaultWorkspace.spotify,
        })

        register_persistent_app("^(Spotify)$")

        local show_spotify = function()
            local w = hl.get_window("class:^(Spotify)$")
            if not w then
                hl.dispatch(hl.dsp.exec_cmd("spotify --password-store=basic"))
                return
            end

            local target_workspace = hl.defaultWorkspace.spotify
            if w.workspace ~= target_workspace then
                hl.dispatch(hl.dsp.window.move({
                    workspace = target_workspace,
                    window = "address:" .. w.address,
                }))
            end

            hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
        end

        hl.bind("SUPER + M", show_spotify)
        hl.bind("XF86Music", show_spotify)

        local pl = "${playerctl} --player=spotify "

        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(pl .. "play-pause"), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd(pl .. "next"), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(pl .. "previous"), { locked = true })

        hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(pl .. "volume 0.05+"), { locked = true })
        hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(pl .. "volume 0.05-"), { locked = true })
      '';
  };
}
