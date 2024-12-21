{ lib, config, pkgs, ... }:

{
  options.apps.rnote.enable = lib.mkEnableOption "Enable RNote";

  config = lib.mkIf config.apps.rnote.enable {
    home.packages = with pkgs; [
      rnote
    ];
  };
}
