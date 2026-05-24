{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  hypr = builtins.elem "keepassxc" config.wayland.windowManager.hyprland.autostart;
in {
  config = mkIf config.programs.keepassxc.enable {
    xdg.mimeApps.defaultApplications = {
      "application/x-keepass2" = ["org.keepassxc.KeePassXC.desktop"];
      "application/x-keepassxc" = ["org.keepassxc.KeePassXC.desktop"];
    };

    programs.keepassxc.settings = {
      Browser = {
        Enabled = true;
        AlwaysAllowAccess = true;
        UpdateBinaryPath = false;
        CustomProxyLocation = "";
        SearchInAllDatabases = true;
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
        MinimizeOnStartup = false;
        MinimizeOnTray = true;
        ShowTrayIcon = true;
        # FontSizeOffset = 1;

        ApplicationTheme = "dark";
        HidePasswords = true;
      };

      General.MinimizeAfterUnlock = false;

      Security = {
        IconDownloadFallback = true;
        QuickUnlock = false;
        LockDatabaseIdle = false;
      };
    };

    services.ssh-agent.enable = true;
    home.packages = with pkgs; [
      libsecret
    ];

    wayland.windowManager.hyprland.modals."keepassxc" = {
      bind = "SUPER SHIFT, K";
      terminal = false;
      exec = "keepassxc";
    };
  };
}
