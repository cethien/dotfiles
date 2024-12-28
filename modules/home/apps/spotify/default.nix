{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.spotify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.deeznuts.apps.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    home.packages = with pkgs; [
      (if config.deeznuts.desktop.gnome.enable then gnomeExtensions.spotify-controls else null)
    ];
  };
}
