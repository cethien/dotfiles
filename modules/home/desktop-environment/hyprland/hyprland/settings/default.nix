{ lib, config, ... }:
{
  imports = [
    ./autostart.nix
    ./general.nix
    ./decorations.nix
    ./animations.nix
    ./bindings.nix
  ];

  config = lib.mkIf config.desktop-environment.hyprland.enable {
    # https://wiki.hyprland.org/Configuring/
    wayland.windowManager.hyprland.settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 0x1440, 1"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/
      "$terminal" = "kitty";
      "$fileManager" = "kitty yazi";
      "$menu" = "rofi -show drun";

      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];


      # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # https://wiki.hyprland.org/Configuring/Master-Layout/
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        follow_mouse = -1;
      };


      # https://wiki.hyprland.org/Configuring/Window-Rules/
      # https://wiki.hyprland.org/Configuring/Workspace-Rules/
      windowrulev2 = [
        "suppressevent maximize, class:.*" # Ignore maximize requests from apps. You'll probably like this.
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0" # Fix some dragging issues with XWayland
      ];
    };
  };
}
