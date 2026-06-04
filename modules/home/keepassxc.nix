{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.keepassxc.enable {
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

    xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
      keepass = {
        desktop = "org.keepassxc.KeePassXC.desktop";
        types = [
          "application/x-keepass2"
          "application/x-keepass"
          "application/x-kdbx"
        ];
      };
    };

    wayland.windowManager.hyprland.modals."keepassxc" = {
      binds = ["SUPER, K"];
      terminal = false;
      exec = "keepassxc";
    };
  };
}
