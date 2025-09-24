{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.gnome-shell;
in {
  config = mkIf cfg.enable {
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
