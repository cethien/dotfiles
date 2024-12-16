{ lib, config, ... }:

{
  options.desktop.environment.plasma.enable = lib.mkEnableOption "Enable plasma DE";

  config = lib.mkIf config.desktop.environment.plasma.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
