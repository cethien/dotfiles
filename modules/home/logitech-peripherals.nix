{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.logitech-peripherals;
in {
  options.programs.logitech-peripherals = {
    enable = mkEnableOption "logitech peripherals (requires to enable wireless support on root level)";
    autostart = mkEnableOption "autostart logitech";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      solaar
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart [
        "[silent] solaar -w hide"
      ];
    };
  };
}
