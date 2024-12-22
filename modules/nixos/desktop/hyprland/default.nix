{ lib, config, pkgs, ... }:

{
  options.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.desktop.hyprland.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };

      autoLogin = {
        enable = config.desktop.autoLogin.enable;
        user = config.desktop.autoLogin.user;
      };
    };

    programs.hyprland.enable = true;
  };
}
