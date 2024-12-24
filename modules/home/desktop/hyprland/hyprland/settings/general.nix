{ lib, config, ... }:

{
  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
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
