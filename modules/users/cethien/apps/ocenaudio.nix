{ lib, config, pkgs, ... }:

{
  options.user.apps.ocenaudio.enable = lib.mkEnableOption "Enable ocenaudio";

  config = lib.mkIf config.user.apps.ocenaudio.enable {
    home.packages = with pkgs; [
      ocenaudio
    ];
  };
}