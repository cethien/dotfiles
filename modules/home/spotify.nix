{
  lib,
  config,
  pkgs,
  spicetify-nix,
  ...
}: let
in {
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  config = {
    programs.spicetify = let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        autoSkipVideo
        hidePodcasts
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        fixMainViewWidth
      ];
    };
    stylix.targets.spicetify.enable = false;
  };
}
