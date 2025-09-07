{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.desktop;
in {
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.deeznuts.desktop = {
    autologinUser = mkOption {
      type = types.passwdEntry types.str;
      default = null;
      description = "autologin user";
    };
  };

  config = {};
}
