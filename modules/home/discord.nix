{
  lib,
  config,
  nixcord,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = config.programs.nixcord;
in {
  imports = [nixcord.homeModules.nixcord];

  options.programs.nixcord.autostart = lib.mkEnableOption "hyprland autostart";

  config = mkIf cfg.enable {
    stylix.targets.nixcord.enable = false;

    services.mako.settings."app-name=vesktop" = {
      default-timeout = 0;
      border-color = "#5865F2";
    };

    programs.nixcord = {
      discord.vencord.enable = true;
      # vesktop.enable = true;
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

    wayland.windowManager.hyprland = {
      modals."discord" = {
        binds = [
          ", XF86Mail"
          "SUPER, F12"
        ];
        terminal = false;
        exec = "discord";
      };
      settings = {
        exec-once = mkIf cfg.autostart [
          "[silent] [workspace special:discord] discord --start-minimized"
        ];
      };
    };
  };
}
