{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem mkMerge mkOption types;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.chat;
in {
  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = {
      chat = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "default chat workspace";
      };
    };
  };

  config = {
    stylix.targets.vesktop.enable = false;
    stylix.targets.nixcord.enable = false;

    programs.vesktop = {
      settings = {
        disableMinSize = true;
        staticTitle = true;
        enableSplashScreen = false;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };
      vencord.settings.plugins = {
        AlwaysExpandRoles.enabled = true;
        BetterGifPicker.enabled = true;
        BlurNSFW.enabled = true;
        ClearURLs.enabled = true;
        CrashHandler.enabled = true;
        FavoriteEmojiFirst.enabled = true;
        FavoriteGifSearch.enabled = true;
        FixSpotifyEmbeds.enabled = true;
        FixYoutubeEmbeds.enabled = true;
        NewGuildSettings.enabled = true;
        NoDevtoolsWarning.enabled = true;
        OpenInApp.enabled = true;
        QuickMention.enabled = true;
        ReverseImageSearch.enabled = true;
        ServerInfo.enabled = true;
        Translate.enabled = true;
        UserMessagesPronouns.enabled = true;
        UserVoiceShow.enabled = true;
        VoiceChatDoubleClick.enabled = true;
        VoiceMessages.enabled = true;
        WebKeybinds.enabled = true;
        WebScreenShareFixes.enabled = true;

        FakeNitro.enabled = true;
        YoutubeAdblock.enabled = true;
        SpotifyCrack.enabled = true;
      };
    };

    wayland.windowManager.hyprland.settings = let
      auto = elem "discord" config.wayland.windowManager.hyprland.autostart;
    in {
      exec-once = mkIf auto (mkMerge [
        (mkIf config.programs.discord.enable ["[silent] discord --start-minimized"])
        (mkIf config.programs.vesktop.enable ["[silent] vesktop --start-minimized"])
      ]);

      windowrule = mkIf (!isNull ws) (mkMerge [
        (mkIf (config.programs.discord.enable) ["match:initial_class discord, workspace ${toString ws}"])
        (mkIf (config.programs.vesktop.enable) ["match:initial_class vesktop, workspace ${toString ws}"])
      ]);
    };
  };
}
