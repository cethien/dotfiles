{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  options.deeznuts.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland desktop";
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };

      autoLogin =
        let
          desktopCfg = config.deeznuts.desktop;
        in
        {
          enable = desktopCfg.autoLogin.enable;
          user = desktopCfg.autoLogin.user;
        };
    };

    wayland.windowManager.hyprland.enable = true;
  };
}
