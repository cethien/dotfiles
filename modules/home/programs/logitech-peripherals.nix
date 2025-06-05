{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.logitech-peripherals;
in {
  options.deeznuts.programs.logitech-peripherals = {
    enable = mkEnableOption "logitech peripherals (requires to enable wireless support on root level)";
    hyprland.autostart.enable = mkEnableOption "hyprland autostart";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      solaar
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] solaar -w hide"
      ];
    };
  };
}
