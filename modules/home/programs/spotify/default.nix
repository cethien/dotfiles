{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.spotify;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./hyprland.nix
    ./gnome.nix
  ];

  options.deeznuts.programs.spotify = {
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
        # theme = spicePkgs.themes.catppuccin;
        # colorScheme = "mocha";
      };
  };
}
