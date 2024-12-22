{ lib, config, ... }:

{
  options.desktop-environment.hyprland.enable = lib.mkEnableOption "Enable Hyprland desktop environment";

  config = lib.mkIf config.desktop-environment.hyprland.enable {
    services.getty.autologinUser = "cethien";
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
