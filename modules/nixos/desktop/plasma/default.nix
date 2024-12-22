{ lib, config, pkgs, ... }:

{
  options.desktop.plasma.enable = lib.mkEnableOption "Enable KDE Plasma Desktop";

  config = lib.mkIf config.desktop.plasma.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        # package = pkgs.kdePackages.sddm;
      };

      autoLogin = {
        enable = config.desktop.autoLogin.enable;
        user = config.desktop.autoLogin.user;
      };
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs; [
      khelpcenter
      kwalletmanager
    ];
    environment.systemPackages = with pkgs.kdePackages; [
      dragon # video player
      kcolorchooser
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
