{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts) mkMimeApps;
  cfg = config.programs.keepassxc;
  uname = config.home.username;
in {
  options.programs.keepassxc.hyprlandAutostart = mkEnableOption "autostart keepassxc";

  config = mkIf cfg.enable {
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
    home.packages = [pkgs.libsecret];

    programs.zen-browser = {
      nativeMessagingHosts = [pkgs.keepassxc];
      profiles."${uname}".extensions.packages = [
        pkgs.firefox-addons.keepassxc-browser
      ];
    };

    programs.chromium = let
      keepassxcChromiumHost = pkgs.writeTextFile {
        name = "keepassxc-chromium-host";
        destination = "/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
        text = builtins.toJSON {
          name = "org.keepassxc.keepassxc_browser";
          description = "KeePassXC integration with Chromium-based browsers";
          path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
          type = "stdio";
          allowed_origins = [
            "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
            "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/"
          ];
        };
      };

      keepassxcChromium = pkgs.symlinkJoin {
        name = "keepassxc-with-chromium";
        paths = [pkgs.keepassxc keepassxcChromiumHost];
      };
    in {
      nativeMessagingHosts = [keepassxcChromium];
      extensions = [
        {id = "oboonakemofpalcgghocfoadofidjkkk";}
      ];
    };

    wayland.windowManager.hyprland = let
      inherit (config.lib.deeznuts.hyprland) mkAutostart;
    in {
      settings.on = mkIf cfg.hyprlandAutostart [(mkAutostart "keepassxc" {})];

      modals."keepassxc" = {
        binds = ["SUPER + K"];
        exec = "keepassxc";
        terminal = false;
      };
    };

    xdg.mimeApps.defaultApplications = mkMimeApps {
      keepass = {
        desktop = "org.keepassxc.KeePassXC.desktop";
        types = [
          "application/x-keepass2"
          "application/x-keepass"
          "application/x-kdbx"
        ];
      };
    };
  };
}
