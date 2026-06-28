{
  lib,
  config,
  nixcord,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.nixcord;

  bin =
    if cfg.vesktop.enable
    then "vesktop"
    else "discord";
in {
  imports = [nixcord.homeModules.nixcord];

  options.programs.nixcord.autostart = lib.mkEnableOption "hyprland autostart";

  config = mkIf cfg.enable {
    stylix.targets.nixcord.enable = false;

    services.mako.settings."app-name=vesktop" = {
      default-timeout = 0;
      border-color = "#5865F2";
    };

    xdg.configFile."autostart/discord.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Name=${
          if bin == "vesktop"
          then "Vesktop"
          else "Discord"
        }
        Comment=All-in-one voice and text chat
        Exec=${bin} --start-minimized
        Icon=${bin}
        Terminal=false
        Type=Application
        Categories=Network;InstantMessaging;
      '';
    };

    programs.nixcord = {
      # vesktop.enable = true;
      discord.enable = !cfg.vesktop.enable;

      discord.vencord.enable = false;
      vesktop.settings = {
        discordBranch = "stable";
        staticTitle = true;
        enableMenu = true;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
        disableMinSize = true;
        enableSplashScreen = false;
      };

      config = {
        frameless = true;
        disableMinSize = true;

        plugins = {
          clearUrls.enable = true;
          crashHandler.enable = true;
          favoriteGifSearch.enable = true;
          fixCodeblockGap.enable = true;
          fixImagesQuality.enable = true;
          fixSpotifyEmbeds.enable = true;
          fixYoutubeEmbeds.enable = true;
          noDevtoolsWarning.enable = true;
          openInApp.enable = true;
          quickMention.enable = true;
          reverseImageSearch.enable = true;
          translate.enable = true;
          userMessagesPronouns.enable = true;
          userVoiceShow.enable = true;
          voiceChatDoubleClick.enable = true;
          voiceDownload.enable = true;
          voiceMessages.enable = true;
          webKeybinds.enable = true;
          webScreenShareFixes.enable = true;

          fakeNitro.enable = true;
          youtubeAdblock.enable = true;
          spotifyCrack.enable = true;

          # vencord-only
          alwaysExpandRoles.enable = true;
          betterGifPicker.enable = true;
          blurNsfw.enable = true;
          favoriteEmojiFirst.enable = true;
          newGuildSettings.enable = true;
          serverInfo.enable = true;
          spotifyControls.enable = true;
          whoReacted.enable = true;
        };
      };
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-discord" =
      # lua
      ''
        hl.bind("SUPER + F12", hl.dsp.exec_cmd("${bin}"))

        hl.window_rule({
            match = {
                class = "^(discord|vesktop)$",
            },
            workspace = hl.defaultWorkspace.chat,
        })
      '';
  };
}
