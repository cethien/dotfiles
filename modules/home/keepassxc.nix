{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  hypr = elem "keepassxc" config.wayland.windowManager.hyprland.autostart;
in {
  config = let
  in
    mkIf config.programs.keepassxc.enable {
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
          # FontSizeOffset = 1;

          ApplicationTheme = "dark";
          HidePasswords = true;
        };

        General.MinimizeAfterUnlock = false;

        Security.IconDownloadFallback = true;
      };

      services.ssh-agent.enable = true;
      home.packages = with pkgs; [
        libsecret
      ];

      home.sessionVariables.SUDO_ASKPASS = "${pkgs.writeShellScriptBin "sudo-askpass" ''
        #!/usr/bin/env bash
        secret-tool lookup id "$(whoami)@$(hostname)" sudo yes 2>/dev/null | head -n1
      ''}/bin/sudo-askpass";

      home.shellAliases.sudo = "${pkgs.writeShellScriptBin "sudo-wrapper" ''
        #!/usr/bin/env bash
        command sudo -A "$@" 2>/dev/null || command sudo "$@"
      ''}/bin/sudo-wrapper";

      services.syncthing.settings = mkIf config.services.syncthing.enable {
        folders.keepass = {
          id = "keepass";
          path = "${config.home.homeDirectory}/.keepass";
          devices = ["hp-430-g7" "xiaomi-15"];
        };
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = mkIf hypr [
          "keepassxc"
        ];

        bind = [
          "SUPER SHIFT, K, exec, ${
            (pkgs.cethien.writeHyprlandLaunchScriptBin "keepassxc" "keepassxc" "org.keepassxc.KeePassXC").bin
          }"
        ];
      };
    };
}
