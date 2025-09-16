{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.deeznuts.desktop;
in {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.deeznuts.desktop = {
    isEnabled = mkOption {
      type = types.bool;
      default = cfg.gnome.enable || cfg.hyprland.enable;
    };
    autologinUser = mkOption {
      type = types.passwdEntry types.str;
      default = null;
      description = "autologin user";
    };
  };
}
