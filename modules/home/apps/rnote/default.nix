{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.rnote.enable = lib.mkEnableOption "Enable RNote";

  config = lib.mkIf config.deeznuts.apps.rnote.enable {
    home.packages = with pkgs; [
      rnote
    ];
  };
}
