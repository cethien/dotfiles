{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      resize_on_border = true;

      # https://wiki.hyprland.org/Configuring/Tearing/
      allow_tearing = false;

      layout = "dwindle";
    };
  };
}
