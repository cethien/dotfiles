{
  lib,
  config,
  nixcord,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.chat;
in {
  imports = [nixcord.homeModules.nixcord];

  options = {
    wayland.windowManager.hyprland = {
      defaultWorkspaces.chat = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = config.wayland.windowManager.hyprland.defaultWorkspaces.browser or null;
        description = "default chat workspace";
      };
    };
    programs.nixcord.autostart = lib.mkEnableOption "hyprland autostart";
  };

  config = {
    stylix.targets.nixcord.enable = false;

    programs.nixcord = {
      discord.enable = false;
      vesktop.enable = true;
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
          ClearURLs.enable = true;
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
          BlurNSFW.enable = true;
          favoriteEmojiFirst.enable = true;
          newGuildSettings.enable = true;
          serverInfo.enable = true;
          spotifyControls.enable = true;
          whoReacted.enable = true;
        };
      };
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf config.programs.nixcord.autostart [
        "[silent] vesktop --start-minimized"
      ];

      windowrule = lib.optionals (ws != null && config.programs.nixcord.enable) [
        "match:initial_class vesktop, workspace ${toString ws}"
      ];
    };
  };
}
