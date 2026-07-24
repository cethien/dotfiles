{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.logitech-peripherals;

  autostartFile = pkgs.makeDesktopItem {
    name = "solaar-autostart";
    exec = "solaar -w hide";
    desktopName = "Solarr (Autostart)";
  };
in {
  options.programs.logitech-peripherals = {
    enable = mkEnableOption "logitech peripherals (requires to enable wireless support on root level)";
    autostart = mkEnableOption "autostart logitech";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.solaar];

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/solaar-autostart.desktop"
    ];
  };
}
