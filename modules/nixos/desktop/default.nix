{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str;
in
{
  imports = [
    ./hyprland
  ];

  options.deeznuts.desktop = {
    autoLogin = {
      enable = mkEnableOption "Enable autologin";
      user = mkOption {
        type = str;
        default = "";
        description = "The user to autologin as";
      };
    };
  };
}
