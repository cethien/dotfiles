{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.programs.spotify;
  isGnome = config.deeznuts.desktop.gnome.enable;
in
{
  config = mkIf (cfg.enable && isGnome) {
    home.packages = with pkgs; [
      gnomeExtensions.spotify-controls
    ];
  };
}
