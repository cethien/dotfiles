{ pkgs, lib, config, ...}: 
{
  options.user.customization.gnome.enable = lib.mkEnableOption "Enable gnome customization";

  config = lib.mkIf config.user.customization.gnome.enable {
    gtk = {
      enable = true;

      catppuccin = {
        enable = true;
        gnomeShellTheme = true;

        tweaks = [ "normal" ];
      };

      iconTheme = {
        name = "Tela-purple-dark";
        package = pkgs.tela-icon-theme;
      };

      cursorTheme = {
        name  = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
      };
    
    };

    qt = {
      enable = true;
      
      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

    dconf.settings = {
      "org/gnome/desktop/session" = {
        idle-delay = "uint32 0";
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = "nothing";
        power-button-action = "interactive";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        # gtk-theme = "catppuccin-mocha-mauve-standard+normal";
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

      "org/gnome/shell/keybindings" = {
        activate-window-menu = "disabled";
        toggle-message-tray = "disabled";
        close = "<Alt>F4";
        maximize = "disabled";
        minimize = ["<Super>comma"];
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
          ];
        };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = { 
        name = "Open Gnome Terminal";
        binding = "<Super>t";
        command = "kgx kgx -e tmux";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Open Gnome Terminal";
        binding = "<Shift><Alt>t";
        command = "kgx -e tmux";
      };
        
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Open File Explorer";
        binding = "<Super>e";
        command = "nautilus";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "Screenshot with Flameshot";
        binding = "<Super><Shift>s";
        command = "flameshot gui";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop" 
          "org.gnome.Geary.desktop" 
          "spotify.desktop" 
          "vesktop.desktop" 
          "code.desktop" 
          "org.prismlauncher.PrismLauncher.desktop"
        ];

        disable-user-extensions = false;
      
        disabled-extensions = [ 
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "light-style@gnome-shell-extensions.gcampax.github.com"
          "status-icons@gnome-shell-extensions.gcampax.github.com"
        ];

        enabled-extensions = [
          "legacyschemeautoswitcher@joshimukul29.gmail.com"
          "tweaks-system-menu@extensions.gnome-shell.fifi.org"
          "quicksettings-audio-devices-hider@marcinjahn.com"
          "quick-settings-audio-panel@rayzeq.github.io"
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
          "blur-my-shell@aunetx"
          "tilingshell@ferrarodomenico.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "gsconnect@andyholmes.github.io"
          "user-theme@gnome-shell-extensions.gcampax.github.com"

          "docker@stickman_0x00.com"
          "spotify-controls@Sonath21"
        ];
      };

      "org/gnome/Console" = {
        use-system-font = false;
        font = "CodeNewRoman Nerd Font Mono 12";
      };
    };
  };

}