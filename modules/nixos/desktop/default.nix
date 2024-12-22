{ lib, ... }:

{
  imports = [
    ./gnome
    ./hyprland
  ];

  options.desktop = {
    autoLogin.enable = lib.mkEnableOption "Enable autologin";
    autoLogin.user = lib.mkOption {
      type = lib.types.passwdEntry;
      default = "";
      description = "The user to autologin as";
    };
  };

}
