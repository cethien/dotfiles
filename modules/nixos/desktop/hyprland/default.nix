{ lib, config, pkgs, ... }:

{
  options.deeznuts.desktop.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };

      autoLogin = {
        enable = config.deeznuts.desktop.autoLogin.enable;
        user = config.deeznuts.desktop.autoLogin.user;
      };
    };

    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      kitty
    ];
  };
}
