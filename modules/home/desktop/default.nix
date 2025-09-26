{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./audio.nix
    ./hyprland
    ./gnome.nix
  ];

  options.programs.desktop = {
    isEnabled = mkOption {
      type = types.bool;
      default = config.programs.gnome-shell.enable || config.wayland.windowManager.hyprland.enable;
    };
  };
}
