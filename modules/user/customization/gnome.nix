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
        gtk-theme = "catppuccin-mocha-mauve-standard+normal";
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
        command = "kgx";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Open Gnome Terminal";
        binding = "<Shift><Alt>t";
        command = "kgx";
      };
        
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Open File Explorer";
        binding = "<Super>e";
        command = "nautilus";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "Screenshot with Flameshot";
        binding = "<Super><Shift>s";
        command = "script --command \"flameshot gui\" /dev/null";
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "firefox.desktop" 
          "org.gnome.Geary.desktop" 
          "spotify.desktop" 
          "vesktop.desktop" 
          "code.desktop" 
          "drawio.desktop"
          "steam.desktop"
          "org.prismlauncher.PrismLauncher.desktop"
        ];

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
          "pip-on-top@rafostar.github.com"
          "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
          "tilingshell@ferrarodomenico.com"
          "color-picker@tuberry"
          
          "docker@stickman_0x00.com"
          "spotify-controls@Sonath21"
        ];
      };

      "org/gnome/Console" = {
        use-system-font = false;
        font = "CodeNewRoman Nerd Font Mono 12";
      };

      "org/gnome/shell/extensions/system-monitor" = {
        show-swap = false;
      };

      "org/gnome/shell/extensions/appindicator" = {
        tray-pos = "center";
      };

      "org/gnome/shell/extensions/color-picker" = {
          enable-systray = false;
          enable-sound = false;
          enable-shortcut = true;
          color-picker-shortcuts = "<Shift><Super>c";
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        hacks-level = 2;
      };
      
      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = false;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        brightness = 0.50;
        opacity = 150;     
        blur-on-overview = false;
        dynamic-opacity = true;
        enable-all = true;
      };

      "org/gnome/shell/extensions/spotify-controls" = {
        controls-position = "left";
        position = "rightmost-left";
      };

      "org/gnome/shell/extensions/docker" = {
        logo = "default";
      };

      "org/gnome/shell/extensions/tilingshell" = {
        enable-snap-assist = false;
        override-window-menu = false;
        restore-window-original-size = false;
        active-screen-edges = false;
        overridden-settings = "{}";
      };
    };      

    home.packages = with pkgs; [     
      (flameshot.override { enableWlrSupport = true; })
    ] ++ (with pkgs.gnomeExtensions; [
      tweaks-in-system-menu
      bluetooth-battery-meter
      system-monitor
      appindicator
      blur-my-shell

      another-window-session-manager
      pip-on-top
      do-not-disturb-while-screen-sharing-or-recording
      tiling-shell
      color-picker
    ]);
        
  };  
}