{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.gnome-shell.enable {
    programs.gnome-shell = {
      extensions = with pkgs.gnomeExtensions; [
        {package = touchup;}
        {package = forge;}
        {package = blur-my-shell;}
        # {package = quick-settings-tweaker;}
        {package = quick-settings-audio-panel;}
        {package = system-monitor;}
      ];
    };
  };
}
