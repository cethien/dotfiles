{ lib, config, pkgs, ... }:

{
  options.desktop-environment.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.desktop-environment.hyprland.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.package = pkgs.kdePackages.sddm;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "cethien";

    programs.hyprland.enable = true;
  };
}
