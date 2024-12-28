{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.spotify;
in
{
  options.deeznuts.apps.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          hidePodcasts
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
      };

    home.packages = (if config.deeznuts.desktop.gnome.enable then with pkgs; [ gnomeExtensions.spotify-controls ] else [ ]);
  };
}
