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
    home.packages = [pkgs.solaar];

    wayland.windowManager.hyprland.settings = let
      inherit (config.lib.deeznuts.hyprland) mkAutostart;
    in {
      on = mkIf cfg.autostart [(mkAutostart "solaar -w hide" {workspace = "unset silent";})];
    };
  };
}
