{ lib, config, pkgs, inputs, ... }:

{
  options.deeznuts.apps.spotify.enable = lib.mkEnableOption "Enable Spotify";

  config = lib.mkIf config.deeznuts.apps.spotify.enable {

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

    home.packages = with pkgs; [
      gnomeExtensions.spotify-controls
    ];

  };
}
