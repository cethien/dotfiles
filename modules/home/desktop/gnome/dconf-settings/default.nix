{ lib, config, ... }:

{
  config = lib.mkIf config.desktop.gnome.enable {
    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 0;
      };

      "org/gnome/desktop/screensaver" = {
        lock-enabled = false;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = "nothing";
        power-button-action = "interactive";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        clock-show-weekday = true;
        enable-hot-corners = false;
        font-antialiasing = "grayscale";
        font-hinting = "slight";
      };

      "org/gnome/desktop/datetime" = {
        automatic-timezone = true;
      };

      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
        action-double-click = "toggle-maximized";
        num-workspaces = 1;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Console.desktop"
          "firefox.desktop"
          "org.gnome.Geary.desktop"
          "spotify.desktop"
          "vesktop.desktop"
          "StreamController.desktop"
          "code.desktop"
          "drawio.desktop"
          "steam.desktop"
          "org.prismlauncher.PrismLauncher.desktop"
          "org.libretro.RetroArch.desktop"
          "com.obsproject.Studio.desktop"
        ];
      };

      "org/gnome/Console" = {
        use-system-font = false;
        font = "CodeNewRoman Nerd Font Mono 12";
      };
    };

  };
}
