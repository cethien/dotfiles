{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./general.nix
    ./decorations.nix
    ./animations.nix
    ./bindings.nix
    ./workspaces.nix
  ];

  config = mkIf cfg.enable {
    # https://wiki.hyprland.org/Configuring/
    wayland.windowManager.hyprland.settings = {

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
      };
    };
  };
}
