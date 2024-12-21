{ lib, config, pkgs, ... }:

{
  options.apps.ocenaudio.enable = lib.mkEnableOption "Enable ocenaudio";

  config = lib.mkIf config.apps.ocenaudio.enable {
    home.packages = with pkgs; [
      ocenaudio
    ];
  };
}
