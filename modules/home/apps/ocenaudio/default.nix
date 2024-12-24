{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.ocenaudio.enable = lib.mkEnableOption "Enable ocenaudio";

  config = lib.mkIf config.deeznuts.apps.ocenaudio.enable {
    home.packages = with pkgs; [
      ocenaudio
    ];
  };
}
