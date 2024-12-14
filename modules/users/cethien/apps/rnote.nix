{ lib, config, pkgs, ... }:

{
  options.user.apps.rnote.enable = lib.mkEnableOption "Enable RNote";

  config = lib.mkIf config.user.apps.rnote.enable {
    home.packages = with pkgs; [
      rnote
    ];
  };
}
