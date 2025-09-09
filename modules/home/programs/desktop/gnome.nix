{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.desktop.gnome;
in {
  options.deeznuts.desktop.gnome.enable = mkEnableOption "gnome customizations";

  config = mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;

      extensions = with pkgs.gnomeExtensions; [
        {package = touchup;}
        {package = forge;}
        {package = blur-my-shell;}
      ];
    };
  };
}
