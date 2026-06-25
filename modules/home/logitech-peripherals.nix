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

    xdg.configFile."autostart/solaar.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Name=Solaar
        Comment=Logitech Device Manager
        Exec=solaar -w hide
        Icon=solaar
        Terminal=false
        Type=Application
        Categories=Utility;
      '';
    };
  };
}
