{ lib, config, pkgs, ... }:

{
  options.user.customization.gnome.extensions.enable = lib.mkEnableOption "Enable gnome extensions";

  config = lib.mkIf config.user.customization.gnome.extensions.enable {
  
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      { package = tweaks-in-system-menu; }
      { package = bluetooth-battery-meter; }
      { package = system-monitor; }
      { package = appindicator; }
      { package = blur-my-shell; }

      { package = another-window-session-manager; }
      { package = fullscreen-avoider; }
      { package = pip-on-top; }
      { package = do-not-disturb-while-screen-sharing-or-recording; }
      { package = tiling-shell; } 
      { package = color-picker; }
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;

        disabled-extensions = [ 
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "light-style@gnome-shell-extensions.gcampax.github.com"
          "status-icons@gnome-shell-extensions.gcampax.github.com"
        ];

        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
 
          "gsconnect@andyholmes.github.io"

          "tweaks-system-menu@extensions.gnome-shell.fifi.org"
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"

          "another-window-session-manager@gmail.com"
          "fullscreen-avoider@noobsai.github.com"
          "pip-on-top@rafostar.github.com"
          "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
          "tilingshell@ferrarodomenico.com"
          "color-picker@tuberry"

          "spotify-controls@Sonath21"
        ];
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        hacks-level = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = false;
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-swap = false;
      };

      "org/gnome/shell/extensions/appindicator" = {
        tray-pos = "left";
      };

      "org/gnome/shell/extensions/color-picker" = {
          enable-systray = false;
          enable-sound = false;
          enable-shortcut = true;
          color-picker-shortcuts = "<Shift><Super>c";
      };

      "org/gnome/shell/extensions/spotify-controls" = {
        controls-position = "left";
        position = "rightmost-left";
      };

      "org/gnome/shell/extensions/tilingshell" = {
        enable-snap-assist = false;
        override-window-menu = false;
        restore-window-original-size = false;
        active-screen-edges = false;
        overridden-settings = "{}";
      };       
    };

  };
}