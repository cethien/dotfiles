{ lib, config, pkgs, ... }:

{
  options.desktop.environment.plasma.enable = lib.mkEnableOption "Enable plasma DE";

  config = lib.mkIf config.desktop.environment.plasma.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs; [
      khelpcenter
      kate
      kwalletmanager
      konsole
    ];

    environment.systemPackages = with pkgs.kdePackages; [
      dragon # video player
      kcolorchooser
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
