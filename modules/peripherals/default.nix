{ system, ... }:

{
  imports = [
    ./print.nix
    ./logitech.nix
    ./xbox-controller.nix
    ./stream-deck.nix
  ];

  logitech.enable = !system.profile.isSurface;
  xbox.enable = !system.profile.isSurface;
  streamdeck.enable = !system.profile.isSurface;
}