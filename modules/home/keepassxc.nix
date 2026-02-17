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
        MinimizeOnStartup = true;
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

    # home.sessionVariables.SUDO_ASKPASS = "${pkgs.writeShellScriptBin "sudo-askpass" ''
    #   #!/usr/bin/env bash
    #   secret-tool lookup id "$(whoami)@$(hostname)" sudo yes 2>/dev/null | head -n1
    # ''}/bin/sudo-askpass";
    #
    # home.shellAliases.sudo = "${pkgs.writeShellScriptBin "sudo-wrapper" ''
    #   #!/usr/bin/env bash
    #   command sudo -A "$@" 2>/dev/null || command sudo "$@"
    # ''}/bin/sudo-wrapper";

    services.syncthing.settings = mkIf config.services.syncthing.enable {
      folders.keepass = {
        id = "keepass";
        path = "${config.home.homeDirectory}/.keepass";
        devices = ["hp-430-g7" "xiaomi-15" "tower-of-power"];
      };
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr [
        "keepassxc"
      ];

      bind = [
        "SUPER SHIFT, K, exec, ${
          (pkgs.cethien.mkHyprLaunchBin "keepassxc" "keepassxc" "org.keepassxc.KeePassXC").bin
        }"
      ];
    };
  };
}
