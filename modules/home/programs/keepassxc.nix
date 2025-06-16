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
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."org.keepassxc.KeePassXC" = "";
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
        MinimizeOnTray = true;
        ShowTrayIcon = true;
        FontSizeOffset = 2;

        ApplicationTheme = "dark";
        HidePasswords = true;
      };

      General.MinimizeAfterUnlock = true;

      Security.IconDownloadFallback = true;
    };

    services.ssh-agent.enable = true;
    home.packages = with pkgs; [
      libsecret

      (writeShellScriptBin "sudo-askpass" ''
        #!/usr/bin/env bash
        secret-tool lookup whoami $(whoami) hostname $(hostname) | head -n1
      '')

      (writeShellScriptBin "sudo-askpass-wrapper" ''
        #!/usr/bin/env bash
        command sudo -A "$@" 2>/dev/null || command sudo "$@"
      '')
    ];

    home.sessionVariables.SUDO_ASKPASS = "$HOME/.nix-profile/bin/sudo-askpass";
    home.shellAliases.sudo = "sudo-askpass-wrapper";

    services.syncthing.settings = mkIf config.services.syncthing.enable {
      folders.keepass = {
        id = "keepass";
        path = "${config.home.homeDirectory}/.keepass";
        devices = ["xiaomi-15"];
      };
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "keepassxc"
      ];
    };
  };
}
