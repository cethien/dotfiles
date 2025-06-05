{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.hyprland;
in {
  options.deeznuts.hyprland = {
    enable = mkEnableOption "hyprland desktop";
    autologinUser = mkOption {
      type = types.passwdEntry types.str;
      default = null;
      description = "autologin user";
    };
  };

  config = mkIf cfg.enable {
    # TODO: replace with simpler autologin without sddm.
    # so far greetd could autostart, getty could login, but could not use both
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };

      autoLogin = {
        enable = true;
        user = cfg.autologinUser;
      };
    };
    programs.hyprland.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
  };
}
