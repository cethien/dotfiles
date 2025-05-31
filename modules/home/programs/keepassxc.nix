{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.keepassxc;
in {
  options.deeznuts.programs.keepassxc = {
    enable = mkEnableOption "keepassxc";
    hyprland = {
      autostart.enable = mkEnableOption "autostart";
    };
  };

  config = mkIf cfg.enable {
    programs.keepassxc.enable = true;
    programs.keepassxc.settings = {
      Browser = {
        Enabled = true;
        AlwaysAllowAccess = true;
        CustomProxyLocation = "";
      };

      FdoSecrets = {
        Enabled = true;
        ConfirmAccessItem = false;
        ConfirmDeleteItem = false;
        ShowNotification = false;
      };

      SSHAgent.Enabled = true;

      PasswordGenerator = {
        Length = 24;
        SpecialChars = false;
      };

      GUI = {
        AdvancedSettings = true;
        MinimizeOnClose = true;
        MinimizeOnStartup = true;
        MinimizeAfterUnlock = true;
        MinimizeOnTray = true;
        ShowTrayIcon = true;
        FontSizeOffset = 2;

        ApplicationTheme = "dark";
        HidePasswords = true;
      };

      Security.IconDownloadFallback = true;
    };

    services.syncthing.settings = mkIf config.services.syncthing.enable {
      folders.keepass = {
        id = "keepass";
        path = "${config.home.homeDirectory}/.keepass";
        devices = ["cethien.me"];
      };
    };

    programs.firefox = mkIf config.programs.firefox.enable {
      profiles.${config.home.username}.extensions.packages = [
        pkgs.nur.repos.rycee.firefox-addons.keepassxc-browser
      ];
      nativeMessagingHosts = [pkgs.keepassxc];
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "keepassxc"
      ];
    };
  };
}
