{ lib, config, ... }:

{
  options.user.customization.gnome.keybindings.enable = lib.mkEnableOption "Enable gnome customization";

  config = lib.mkIf config.user.customization.gnome.keybindings.enable {

    dconf.settings = {
      "org/gnome/shell/keybindings" = {
        activate-window-menu = "disabled";
        toggle-message-tray = "disabled";
        close = "<Alt>F4";
        maximize = "disabled";
        minimize = [ "<Super>comma" ];
        move-to-monitor-down = "disabled";
        move-to-monitor-left = "disabled";
        move-to-monitor-right = "disabled";
        move-to-monitor-up = "disabled";
        move-to-workspace-down = "disabled";
        move-to-workspace-up = "disabled";
        toggle-maximized = "disabled";
        unmaximize = "disabled";

        panel-run-dialog = "['<Super>r']";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Open Terminal";
        binding = "<Super>t";
        command = "kgx";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Open Terminal";
        binding = "<Ctrl><Alt>t";
        command = "kgx";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Open File Explorer";
        binding = "<Super>e";
        command = "nautilus";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "Screenshot";
        binding = "<Super><Shift>s";
        command = "script --command \"flameshot gui\" /dev/null";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        name = "Open System Monitor";
        binding = "<Shift><Control>Escape";
        command = "gnome-system-monitor";
      };
    };

  };
}
