{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption elem;
  cfg = config.programs.logitech-peripherals;
  hypr = elem "logitech" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.logitech-peripherals = {
    enable = mkEnableOption "logitech peripherals (requires to enable wireless support on root level)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      solaar
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr [
        "[silent] solaar -w hide"
      ];
    };
  };
}
