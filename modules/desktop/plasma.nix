{ lib, config, ... }:

{
  options.desktop.plasma.enable = lib.mkEnableOption "Enable plasma DE";

  config = lib.mkIf config.desktop.plasma.enable {
    # services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}